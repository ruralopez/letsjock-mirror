class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
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
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(:phone => 18, :citybirth => "City", :country => "Country", :resume => "", :email => params[:email], :password => params[:password], :name => params[:name], :lastname => params[:lastname], :isSponsor => false, :authentic_email => false)

    respond_to do |format|
      if @user.save
        publisher = Publisher.new(:user_id => @user.id, :pub_type => "U")
        if publisher.save
          UserMailer.registration_confirmation(@user).deliver
          Notification.new(:user_id => @user.id, :read => false, :not_type => "999").save
          flash[:success] = "Welcome #{@user.full_name}! We sent you a confirmation e-mail to #{@user.email}. Now you can complete your profile!"
          format.html { redirect_to root_url }
        end
      else
        format.html { render :action => "new" }
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
          
          #Guarda el deporte principal del usuario
          @user.set_sport_main(params[:sport_id])
          
          Activity.new(:publisher_id => Publisher.find_by_user_id(@user.id).id, :act_type => "000").save
          
          format.html { redirect_to @user, :notice => 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @user.errors, :status => :unprocessable_entity }
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
    #@usersport = UserSport.all
    @user = User.find(params[:id])
    
    if @user.isSponsor?
      # Eventos en los que ha participado      
      @next_events = Event.find(:all, :conditions => ['user_id = ? AND date >= ?', @user.id, DateTime.now]).to_set.classify { |event| event.date.month }
      @prev_events = Event.find(:all, :conditions => ['user_id = ? AND date < ?', @user.id, DateTime.now])
    else
      #Juntar competitions, teams, trains, results y recognitions como athlete experiences
      @competitions = Competition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "init DESC, end DESC")
      @teams = Team.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "init DESC, end DESC")
      @trains = Train.all(:conditions => ['user_id = ?', @user.id], :order => "init DESC, end DESC")
      @results = Result.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "date DESC")
      @recognitions = Recognition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "date DESC")
      @athleteExperiences = (@competitions + @teams + @trains + @results + @recognitions)
      #Juntar Works
      @teams_work = Team.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "init DESC")
      @trains_work = Trainee.all(:conditions => ['user_id = ?', @user.id], :order => "init DESC")
      @results_work = Result.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "date DESC")
      @recognitions_work = Recognition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "date DESC")
      @workExperiences = (@teams_work + @trains_work + @results_work + @recognitions_work)
      @works = Work.all(:conditions => ['user_id = ?', @user.id], :order => "init DESC, end DESC")
      #Juntar Educational
      @educations = Education.all(:conditions => ['user_id = ?', @user.id])
      
      #Crear variable para poder crear competition, team, train, result o recognition.
      @recognition = @competition = @result = @team = @train = @trainee = @work = @education = NullObject.new # La clase NullObject está definida al final
      
      # Eventos en los que ha participado
      @events = UserEvent.all(:conditions => ['user_id = ?', @user.id])
    end
    
    #Juntar photos y videos que el usuario ya tiene
    @photos = Photo.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    @videos = Video.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    #Crear variables photo y video para poder subir
    @photo = @user.photos.build if signed_in?
    @video = @user.videos.build if signed_in?
    #Sacando todos los sports
    @sports = Sport.order("parent_id ASC, name ASC").to_json(:only => [ :id, :name, :parent_id ])
    #Creando array de Countries para auto-complete
    @countries = Country.select('name').all.map(&:name)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
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
    redirect_to @user
  end
  
  def change_bg_pic
    @user = User.find(params[:id])
    
    if @user.preferences[:bgpicture] && @user.preferences[:bgpicture]!= "" && !(Photo.exists?(:url => @user.preferences[:bgpicture], :user_id => params[:id]))
      Photo.create({:title => "Test", :url => @user.preferences[:bgpicture], :user_id => params[:id]})
    end
    
    @user.preferences[:bgpicture] = params[:url]
    @user.update_attribute(:preferences, @user.preferences)
    redirect_to @user
  end

  def social
    if signed_in?
      if params[:following]
        @tab2 = true
      end
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
      sign_in(@user)
      redirect_to profile_path(@user)
    else
      if params[:token] && params[:token] == @user.email_token
        @user.update_attributes(:authentic_email => true)
        flash[:success] = "Your email is now validated."
        redirect_to welcome_path(:token => @user.email_token)
      else
        redirect_to root_url
      end
    end
  end

  def profile_new
    if params[:token] && User.exists?(:email_token => params[:token])
      @user = User.find_by_email_token(params[:token])
    else
      redirect_to root_url
    end
    @sports = Sport.order("parent_id ASC, name ASC").to_json(:only => [ :id, :name, :parent_id ])
  end

  def add_new
    if signed_in? && current_user.id == params[:user_id].to_i
      if ( params[:sport_id] != "" || params[:company] != "" ) && params[:init] != ""
        
        # Si está editando trae params[:edit_profile] => true
        edit_profile = true if params[:edit_profile]
        
        # WORK
        if params[:work_id] && params[:company] != "" && params[:role] != ""
          work = Work.find(params[:work_id])
        elsif params[:company] && params[:role] && params[:company] != "" && params[:role] != ""
          work = Work.new
        elsif params[:work_id]
          Work.find(params[:work_id]).destroy
          
          return redirect_to current_user
        end
        
        if work
          work.update_attributes(:company => params[:company], :role => params[:role], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :country_id => 46, :location => params[:city])
          as_athlete = false
        else
          work = NullObject.new
          as_athlete = true
        end
        
        if params[:sport_id] != ""
          UserSport.new(:user_id => current_user.id, :sport_id => params[:sport_id]).save unless UserSport.exists?(:user_id => current_user.id, :sport_id => params[:sport_id])
        end
        
        # TEAM
        if params[:team_id] && params[:team_name] != "" && params[:team_category] != "" #Existente
          team = Team.find(params[:team_id])
        elsif params[:team_name] != "" && params[:team_category] != "" #Nuevo
          team = Team.new
        elsif params[:team_id] # Eliminar
          Team.find(params[:team_id]).destroy
        end
        
        if team
          team.update_attributes( :name => params[:team_name], :category => params[:team_category], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :as_athlete => as_athlete, :work_id => work.id )
        else
          team = NullObject.new
        end
        
        # TRAIN
        if params[:train_id] && params[:train_name] != "" #Existente
          train = Train.find(params[:train_id])
        elsif params[:train_name] != nil && params[:train_name] != "" #Nuevo
          train = Train.new
        elsif params[:train_id] # Eliminar
          Train.find(params[:train_id]).destroy
        end
        
        if train
          train.update_attributes( :name => params[:train_name], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :team_id => team.id )
        end
        
        # RESULT Y COMPETITION
        if params[:competition_id] && params[:result_id] && params[:result_position] != "" && params[:competition_name] != "" #Existente
          competition = Competition.find(params[:competition_id])
          result = Result.find(params[:result_id])
        elsif params[:result_position] != "" && params[:competition_name] != "" #Nuevo
          competition = Competition.new
          result = Result.new
        elsif params[:competition_id] && params[:competition_name] == "" # Eliminar competiciones y resultados en cascada
          Competition.find(params[:competition_id]).destroy
        end
        
        if competition
          competition.update_attributes( :name => params[:competition_name], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :team_id => team.id, :as_athlete => as_athlete, :work_id => work.id )
          result.update_attributes( :position => params[:result_position], :value => params[:result_value], :var => params[:result_var], :sport_id => params[:sport_id], :user_id => params[:user_id], :competition_id => competition.id, :date => params[:init], :team_id => team.id, :as_athlete => as_athlete, :work_id => work.id )
        else
          competition = NullObject.new
        end
        
        # RECOGNITION
        if params[:recognition_id] && params[:recognition_title] != "" && params[:recognition_by] != "" #Existente
          recognition = Recognition.find(params[:recognition_id])
        elsif params[:recognition_title] != "" && params[:recognition_by] != "" #Nuevo
          recognition = Recognition.new
        elsif params[:recognition_id] # Eliminar
          Recognition.find(params[:recognition_id]).destroy
        end
        
        if recognition
          recognition.update_attributes( :description => params[:recognition_title], :awarded_by => params[:recognition_by], :sport_id => params[:sport_id], :user_id => params[:user_id], :date => params[:init], :competition_id => competition.id, :team_id => team.id, :as_athlete => as_athlete, :work_id => work.id )
        end
      else
        flash[:error] = "You must complete all the required params."
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
      if params[:init] != "" && params[:end] != "" && ( params[:highschool_name] != "" || params[:school_name] != "")
        
        if params[:education_id]
          education = Education.find(params[:education_id])
        else
          education = Education.new
        end
        
        if params[:highschool_name] != ""
          education.update_attributes(:name => params[:highschool_name], :career => params[:country], :rank => params[:rank], :gda => params[:gda], :ncaa => params[:ncaa], :country_id => 46, :location => params[:city], :user_id => params[:user_id], :init => params[:init], :end => params[:end])
        elsif params[:school_name] != ""
          education.update_attributes(:name => params[:school_name], :career => params[:country], :degree => params[:degree], :country_id => 46, :location => params[:city], :user_id => params[:user_id], :init => params[:init], :end => params[:end])
        end
      else
        flash[:error] = "You must complete all the required params."
      end
      
      redirect_to current_user
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_path
    end
  end
  
  def edit_profile
    if signed_in?
      @recognition = @competition = @result = @team = @train = @trainee = @work = @education = NullObject.new # La clase NullObject está definida al final
      @edit_profile = true
      
      case params[:object_type]
        when 'work' #Si viene solo work
          @work = Work.find(params[:object_id])
        when 'recognition'
          @recognition = Recognition.find(params[:object_id])
          @sport_id = @recognition.sport_id
          
          @work = @recognition.work if @recognition.work_id
          @competition = @recognition.competition if @recognition.competition_id
          @team = @recognition.team if @recognition.team_id
        when 'competition'
          @competition = Competition.find(params[:object_id])
          @sport_id = @competition.sport_id
          
          @work = @competition.work if @competition.work_id
          @team = @competition.team if @competition.team_id
        when 'team'
          @team = Team.find(params[:object_id])
          @sport_id = @team.sport_id
          
          @work = @team.work if @team.work_id
        when 'train'
          @train = Train.find(params[:object_id])
          @sport_id = @train.sport_id
        when 'education'
          @education = Education.find(params[:object_id])
      end
      
      if @train.id == nil && Train.find(:all, :conditions => ['user_id = ? AND sport_id = ? AND team_id = ?', current_user.id, @sport_id, @team.id]).count > 0
        @train = Train.find(:all, :conditions => ['user_id = ? AND sport_id = ? AND team_id = ?', current_user.id, @sport_id, @team.id]).first
      elsif @train.id == nil && Train.find(:all, :conditions => ['user_id = ? AND sport_id = ?', current_user.id, @sport_id]).count > 0
        @train = Train.find(:all, :conditions => ['user_id = ? AND sport_id = ?', current_user.id, @sport_id]).first
      end
      
      if @work.id?
        @init = @work.init
        @end = @work.end
      elsif @competition.id?
        @result = Result.find(:all, :conditions => ['user_id = ? AND sport_id = ? AND competition_id = ?', current_user.id, @sport_id, @competition.id]).first
        @init = @competition.init
        @end = @competition.end
      elsif @team.id?
        @init = @team.init
        @end = @team.end
      end
      
      #Sacando todos los sports para los botones de agregar entrada
      @sports = Sport.order("parent_id ASC, name ASC").to_json(:only => [ :id, :name, :parent_id ])
      
      respond_to do |format|
        if @work.id?
          format.js { render 'users/_working_profile_form' }
        elsif @education.id?
          format.js { render 'educations/_form' }
        else
          format.js { render 'users/_profile_form' }
        end
      end
    else
      redirect_to root_path
    end
  end
  
  def remove_profile
    if signed_in?
      case params[:object_type]
        when 'work' #Si viene solo work
          Work.find(params[:object_id]).destroy
        when 'education'
          Education.find(params[:object_id]).destroy
        when 'recognition'
          recognition = Recognition.find(params[:object_id])
          
          recognition.competition.destroy if recognition.competition_id
          
          if recognition.team_id
            team = recognition.team
          end
          
          recognition.destroy
        when 'competition'
          competition = Competition.find(params[:object_id])
          
          if competition.team_id
            team = competition.team
          end
          
          competition.destroy
        when 'team'
          team = Team.find(params[:object_id])
        when 'train'
          Train.find(params[:object_id]).destroy
      end
      
      # Saqué la logica del team porque se repetía bastante en el case
      if team
        if team.trains
          team.trains.each do |t|
            t.destroy
          end
        end
        
        team.destroy
      end
      
      redirect_to current_user
    else
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
    respond_to do |format|
      if User.exists?(params[:user][:id])
        @user = User.find(params[:user][:id])
        @user.update_attributes(params[:user])
      else
        @user = User.create(params[:user])
        
        if @user.save
          publisher = Publisher.create(:user_id => @user.id, :pub_type => "U")
        end
      end
      
      if @user.save
        format.html { redirect_to '/profile/' + @user.id.to_s, :notice => 'Sponsor was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "sponsor_new" }
        format.json { render :json => @user, :status => :unprocessable_entity }
      end
    end
  end
  
  def sponsor_edit
    @user = User.find(params[:id])
    render "sponsor_new"
  end

  def invite
    if signed_in?
      @user = current_user
      UserMailer.invitation({ :name => @user.full_name, :email => params[:email], :message => params[:message] }).deliver
      redirect_to request.referer
    end
  end

  def read_notification
    notification = Notification.find(params[:id])
    notification.update_attributes(:read => true)
    if notification.not_type == "003"
      redirect_to User.find(notification.user2_id)
    elsif notification.not_type == "104"
      redirect_to Event.find(notification.event_id)
    elsif notification.not_type == "999"
      redirect_to User.find(notification.user_id)
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

  def forgotten_password

  end

  def new_password_request
    if User.exists?(:email => params[:email])
      @user = User.find_by_email(params[:email])
      UserMailer.new_password(@user).deliver
    end
    flash[:success] = "An email with further instructions has been sent to " + params[:email]
    redirect_to root_url
  end

  def confirmed_new_password
    if User.exists?(:email_token => params[:token])
      @user = User.find_by_email_token(params[:token])
      @token = params[:token]
      respond_to do |format|
      format.html
      format.json
      end
    else
      redirect_to root_url
    end
  end

  def change_password
    if User.exists?(:email_token => params[:token])
        if params[:password] == params[:password_confirmation]
          @user = User.find_by_email_token( params[:token])
          if @user.update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation])
            flash[:success] = "Your password has been changed."
            redirect_to root_url
          end
        else
          flash[:error] = "Passwords did not match."
        end
    else
    end
  end

  def send_mail_auth
    if params[:email] && User.exists?(:email => params[:email].downcase)
      user = User.find_by_email(params[:email].downcase)
      unless user.authentic_email
        UserMailer.registration_confirmation(user).deliver
      end
    end
    flash[:success] = "The registration email has been sent again."
    redirect_to root_url
  end

end

class NullObject
  def method_missing(*args, &block)
    nil
  end
  
  def id
    nil
  end
end
