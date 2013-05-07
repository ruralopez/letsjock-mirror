class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    redirect_to '/profile/' + @user.id.to_s
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(:phone => 18, :citybirth => "City", :country => "Country", :resume => "", :email => params[:email], :password => params[:password], :name => params[:name], :lastname => params[:lastname], :isSponsor => false)

    respond_to do |format|
      if @user.save
        publisher = Publisher.new(:user_id => @user.id, :pub_type => "U")
        if publisher.save
          sign_in @user
          UserMailer.registration_confirmation(@user).deliver
          format.html { redirect_to '/profile/' + @user.id.to_s, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @user, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if signed_in? && current_user.id == @user.id
      respond_to do |format|
        if @user.update_attributes(params[:user])

          Activity.new(:publisher_id => Publisher.find_by_user_id(@user.id).id, :act_type => "000").save

          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if signed_in? && current_user.id == 1
      @user.destroy

      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def profile
    @usersport = UserSport.all
    @user = User.find(params[:id])
    
    if @user.isSponsor?
      # Eventos en los que ha participado      
      @next_events = Event.find(:all, :conditions => ['user_id = ? AND date >= ?', @user.id, DateTime.now]).to_set.classify { |event| event.date.month }
      @prev_events = Event.find(:all, :conditions => ['user_id = ? AND date < ?', @user.id, DateTime.now])
    else
      #Juntar competitions, teams, trains, results y recognitions como athlete experiences
      @competitions = Competition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "init desc")
      @teams = Team.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "init desc")
      @trains = Train.all(:conditions => ['user_id = ?', @user.id], :order => "init desc")
      @results = Result.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "date desc")
      @recognitions = Recognition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "date desc")
      @athleteExperiences = (@competitions + @teams + @trains + @results + @recognitions)
      #Juntar Works
      @teams_work = Team.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "init desc")
      @trains_work = Trainee.all(:conditions => ['user_id = ?', @user.id], :order => "init desc")
      @results_work = Result.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "date desc")
      @recognitions_work = Recognition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "date desc")
      @workExperiences = (@teams_work + @trains_work + @results_work + @recognitions_work)
      @works = Work.all(:conditions => ['user_id = ?', @user.id])
      #Juntar Educational
      @educations = Education.all(:conditions => ['user_id = ?', @user.id])
      #Crear variable para poder crear competition, team, train, result o recognition.
      @competition = @user.competitions.build if signed_in?
      @team = @user.teams.build if signed_in?
      @train = @user.trains.build if signed_in?
      @result = @user.results.build if signed_in?
      @recognition = @user.recognitions.build if signed_in?
      @work = @user.works.build if signed_in?
      @education = @user.educations.build if signed_in?
      
      # Eventos en los que ha participado
      @events = UserEvent.all(:conditions => ['user_id = ?', @user.id])
    end
    
    #Juntar photos y videos que el usuario ya tiene
    @photos = Photo.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    @videos = Video.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    #Crear variables photo y video para poder subir
    @photo = @user.photos.build if signed_in?
    @video = @user.videos.build if signed_in?
    #Sacando todos los sports para los botones de agregar entrada
    @sports = Sport.where("parent_id IS NULL").sort_by(&:name)
    #Creando array de Countries para auto-complete
    @countries = Country.select('name').all.map(&:name)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def change_profile_pic

    @user = User.find(params[:id])

    if @user.profilephotourl != "default-profile.png"
      if  !(Photo.exists?(:url => @user.profilephotourl, :user_id => params[:id]))
        Photo.create({:title => "Test", :url => @user.profilephotourl, :user_id => params[:id]})
      end
    end

    @user.update_attribute(:profilephotourl, params[:url])

    redirect_to current_user

  end

  def social

    if signed_in?
      @user = User.find(params[:id])
      @followers = @user.followers
      @followed = @user.followed_users
      @message = Message.new

      @followers_list = Hash.new

      unless @followers.blank?
        @followers.each do |user|
          @followers_list[user.full_name] = user.id
        end
      end

      suma = @followers + @followed

      @friends_list = []
      suma.each do |user|
        @friends_list.push(user.full_name)
      end

    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_path
    end

  end

  def pictures

    if signed_in?
      @user = User.find(params[:id])
      @photos = Photo.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
      @videos = Video.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
      @photo = @user.photos.build if signed_in?
      @video = @user.videos.build if signed_in?

    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_path
    end

  end

  def auth_email
    @user = User.find(params[:id])
    if @user.authentic_email
      flash[:error] = "Your email has already been validated."
      redirect_to profile_path(current_user)
    else
      if params[:token] && params[:token] == @user.email_token
        @user.update_attributes(:authentic_email => true)
        flash[:success] = "Your email is now validated."
        redirect_to welcome_path
      else
        flash[:error] = "Wrong token."
      end
    end
  end

  def profile_new
    @user = current_user

  end

  def add_new
    if signed_in? && current_user.id == params[:user_id].to_i
      if params[:sport_id] != "" && params[:init] != ""
        UserSport.new(:user_id => current_user.id, :sport_id => params[:sport_id]).save unless UserSport.exists?(:user_id => current_user.id, :sport_id => params[:sport_id])
        if params[:team_name] != "" && params[:team_category] != ""
          @team = Team.new(:name => params[:team_name], :category => params[:team_category], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :as_athlete => true)
          @team.save
        end
        if params[:train_name] != ""
          if @team
            @train = Train.new(:name => params[:train_name], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :team_id => @team.id)
          else
            @train = Train.new(:name => params[:train_name], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end])
          end
          @train.save

        end
        if params[:result_position] != "" && params[:competition_name] != ""
          if @team
            @competition = Competition.new(:name => params[:competition_name],:sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :team_id => @team.id, :as_athlete => true )
            @competition.save
            @result = Result.new(:position => params[:result_position],:value => params[:result_value], :var => params[:result_var], :sport_id => params[:sport_id], :user_id => params[:user_id], :competition_id => @competition.id, :date => params[:init], :team_id => @team.id, :as_athlete => true )
          else
            @competition = Competition.new(:name => params[:competition_name],:sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :as_athlete => true )
            @competition.save
            @result = Result.new(:position => params[:result_position],:value => params[:result_value], :var => params[:result_var], :sport_id => params[:sport_id], :user_id => params[:user_id], :competition_id => @competition.id, :date => params[:init], :as_athlete => true)
          end
          @result.save
        end
        if params[:award_title] != "" && params[:award_by] != ""
          if @team && @competition
            @recognition = Recognition.new(:description => params[:award_title], :awarded_by => params[:award_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :competition_id => @competition.id, :team_id => @team.id, :as_athlete => true)
          elsif  @competition
            @recognition = Recognition.new(:description => params[:award_title], :awarded_by => params[:award_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :competition_id => @competition.id, :as_athlete => true)
          elsif  @team
            @recognition = Recognition.new(:description => params[:award_title], :awarded_by => params[:award_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :team_id => @team.id, :as_athlete => true)
          else
            @recognition = Recognition.new(:description => params[:award_title], :awarded_by => params[:award_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :as_athlete => true)
          end
          @recognition.save
        end
      else
        flash[:error] = "You must complete all the required params."
        redirect_to current_user
      end
      redirect_to current_user
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_path
    end
  end

  def add_new_working
    if signed_in? && current_user.id == params[:user_id].to_i
      if params[:sport_id] != "" && params[:init] != "" && params[:company] != "" && params[:role] != ""
        UserSport.new(:user_id => current_user.id, :sport_id => params[:sport_id]).save unless UserSport.exists?(:user_id => current_user.id, :sport_id => params[:sport_id])
        @work = Work.new(:company => params[:company], :role => params[:role], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :country_id => 1, :location => params[:city])
        @work.save
        if params[:team_name] != "" && params[:team_category] != ""
          @team = Team.new(:name => params[:team_name], :category => params[:team_category], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :as_athlete => false, :work_id => @work.id)
          @team.save
        end
        if params[:trainee_name] != ""
          if @team
            @trainee = Trainee.new(:name => params[:trainee_name], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :team_id => @team.id, :work_id => @work.id)
          else
            @trainee = Trainee.new(:name => params[:trainee_name], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :work_id => @work.id)
          end
          @trainee.save

        end
        if params[:result_position] != "" && params[:result_value] != "" && params[:result_var] != "" && params[:competition_name] != ""
          if @team
            @competition = Competition.new(:name => params[:competition_name],:sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :team_id => @team.id, :as_athlete => false, :work_id => @work.id)
            @competition.save
            @result = Result.new(:position => params[:result_position],:value => params[:result_value], :var => params[:result_var], :sport_id => params[:sport_id], :user_id => params[:user_id], :competition_id => @competition.id, :date => params[:init], :team_id => @team.id, :as_athlete => false, :work_id => @work.id)
          else
            @competition = Competition.new(:name => params[:competition_name],:sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :as_athlete => false, :work_id => @work.id)
            @competition.save
            @result = Result.new(:position => params[:result_position],:value => params[:result_value], :var => params[:result_var], :sport_id => params[:sport_id], :user_id => params[:user_id], :competition_id => @competition.id, :date => params[:init], :as_athlete => false, :work_id => @work.id)
          end
          @result.save
        end
        if params[:award_title] != "" && params[:award_by] != ""
          if @team && @competition
            @recognition = Recognition.new(:description => params[:award_title], :awarded_by => params[:award_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :competition_id => @competition.id, :team_id => @team.id, :as_athlete => false, :work_id => @work.id)
          elsif  @competition
            @recognition = Recognition.new(:description => params[:award_title], :awarded_by => params[:award_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :competition_id => @competition.id, :as_athlete => false, :work_id => @work.id)
          elsif  @team
            @recognition = Recognition.new(:description => params[:award_title], :awarded_by => params[:award_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :team_id => @team.id, :as_athlete => false, :work_id => @work.id)
          else
            @recognition = Recognition.new(:description => params[:award_title], :awarded_by => params[:award_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :as_athlete => false, :work_id => @work.id)
          end
          @recognition.save
        end
      else
        flash[:error] = "You must complete all the required params."
        redirect_to current_user
      end
      redirect_to current_user
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_path
    end
  end

  def add_new_educational
    if signed_in? && current_user.id == params[:user_id].to_i
      if params[:init] != "" && params[:end] != ""
        if params[:highschool_name] != ""
          @education = Education.new(:name => params[:highschool_name], :rank => params[:rank], :gda => params[:gda], :ncaa => params[:ncaa], :country_id => 1, :location => params[:city], :user_id => params[:user_id], :init => params[:init], :end => params[:end])
          @education.save
        elsif params[:school_name] != ""
          @education = Education.new(:name => params[:school_name], :career => params[:career], :degree => params[:degree], :country_id => 1, :location => params[:city], :user_id => params[:user_id], :init => params[:init], :end => params[:end])
          @education.save
        else
          flash[:error] = "You must complete all the required params."
          redirect_to current_user
        end
      else
        flash[:error] = "You must complete all the required params."
        redirect_to current_user
      end
      redirect_to current_user
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_path
    end
  end
  
  def sponsor_new
    if current_user.isAdmin?
      @user = User.new
    else
      redirect_to news_path
    end
  end
  
  def sponsor_create
    puts YAML::dump(params)
    @user = User.create(params[:user])
    @user.save
    
    respond_to do |format|
      if @user.save
        publisher = Publisher.new(:user_id => @user.id, :pub_type => "U")
        if publisher.save
          format.html { redirect_to '/profile/' + @user.id.to_s, notice: 'Sponsor was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        end
      else
        format.html { render action: "sponsor_new" }
        format.json { render json: @user, status: :unprocessable_entity }
      end
    end
  end

  def read_notification
    notification = Notification.find(params[:id])
    notification.update_attributes(:read => true)
    if notification.not_type == "003"
      redirect_to User.find(notification.user2_id)
    elsif notification.not_type == "104"
      redirect_to Event.find(notification.event_id)
    end
  end

  def search
    if params[:query]
      @query = params[:query]
      queries = @query.split(" ")
      @result = []
      queries.each do |qy|
        @result += User.all(:conditions => ["lower(name) LIKE ? OR lower(lastname) LIKE ?", "%#{qy}%".downcase, "%#{qy}%".downcase ]).sort_by(&:id)
      end
      @result = @result.uniq
      unless @result != []
        @result = -1
      end
    end
    @filters = User.new
    @sports_list = Sport.select('name').all.map(&:name)
  end

end
