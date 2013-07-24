class UsersController < ApplicationController
  before_filter :verify_login, :only => [:index, :show, :new, :edit, :profile, :pictures, :typeahead, :add_admin, :sponsor_new, :sponsor_create, :sponsor_edit, :sponsor_events, :like, :add_comment, :highlight, :ask_recommendation, :create_recommendation, :ask_sponsoring, :confirm_sponsoring, :add_agent]
  
  def verify_login
    unless signed_in?
      flash[:error] = "You must be logged in."
      redirect_to root_path and return
    end
  end
  
  # GET /users
  # GET /users.json
  def index
=begin
    @users = User.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
=end

    redirect_to news_path
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
    @user = User.new(:phone => 18, :citybirth => "City", :country_id => 46, :resume => "", :email => params[:email], :password => params[:password], :name => params[:name], :lastname => params[:lastname], :isSponsor => false, :authentic_email => false, :gender => params[:gender])

    if @user.save
      respond_to do |format|
        publisher = Publisher.new(:user_id => @user.id, :pub_type => "U")
        
        if publisher.save
          UserMailer.registration_confirmation(@user).deliver
          Notification.new(:user_id => @user.id, :read => false, :not_type => "999").save
          
          #Todos siguen a LetsJock por defecto (profile: 1)
          @user.follow!(User.find(1))
          
          flash[:success] = "Welcome #{@user.full_name}! We sent you a confirmation e-mail to #{@user.email} to complete registration process!"
          format.html { redirect_to root_url }
        end
      end
    else
      flash[:error] = "Email is already  registered."
      redirect_to root_path
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
          params.each do |key, value|
            if key.start_with?("sport_id") && value != ""
              @user.set_sport(value.to_s, key.slice(-1, 1).to_i + 1)
            end
          end

          Activity.new(:publisher_id => Publisher.find_by_user_id(@user.id).id, :act_type => "000").save

          format.html {
            if params[:profile_picture] && params[:profile_picture] != "" #Sube la foto de perfil si viene de la vista profile_new
              url = Photo.upload_file(params[:profile_picture])

              if url && url != ""
                Photo.create(:user_id => @user.id, :url => url)
                @user.update_attribute(:profilephotourl, url)
              end
            end
            
            # Si viene con un redirect
            if session[:redirected_by] && session[:redirected_by] != ""
              tmp = session[:redirected_by]
              session[:redirected_by] = nil
              redirect_to tmp and return
            elsif request.referer.include?("/settings")
              redirect_to request.referer
            else
              redirect_to '/profile/' + @user.id.to_s, :notice => 'User was successfully updated.'
            end
          }
          format.json { render :json => { :status => true } }
        else
          format.html { redirect_to profile_path(current_user) }
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
    @user = User.find(params[:id])
    
    if @user.id != current_user.id
      userstats = Stat.all(:conditions => ["user_id = ? AND type = ? AND info = ? AND created_at between ? AND ?", current_user.id, "User", @user.id, Time.zone.now.beginning_of_day, Time.zone.now.end_of_day])
      if userstats.empty? 
        Stat.create(:user_id => current_user.id, :type => "User", :info => @user.id)
      end
    end

    if @user.isSponsor?
      posts = Post.where(:user_id => @user.id).order("created_at ASC")
      events = Event.where(:user_id => @user.id).order("created_at ASC")
      @posts_combined = ( posts + events ).sort_by(&:created_at).reverse
      @myevents = events
    else
      #Juntar competitions, teams, trains, results y recognitions como athlete experiences
      @competitions = Competition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "end DESC, init DESC")
      @teams = Team.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "end DESC, init DESC")
      @trains = Train.all(:conditions => ['user_id = ?', @user.id], :order => "end DESC, init DESC")
      @results = Result.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "date DESC") # Podría comentarlo?
      @recognitions = Recognition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "date DESC")
      
      # Solo deportes que no tengan hitos
      sports_exclude = []
      (@competitions + @teams + @trains + @results + @recognitions).each do |milestone|
        sports_exclude.push(milestone.sport_id)
      end
      
      @user_sports = UserSport.all(:conditions => ['user_id = ? AND sport_id NOT IN ( ? ) AND position IS NULL AND init IS NOT NULL AND end IS NOT NULL', @user.id, sports_exclude.length > 0 ? sports_exclude : 0 ], :order => "end DESC, init DESC")
      
      @athleteExperiences = (@competitions + @teams + @trains + @results + @recognitions + @user_sports).to_set.classify { |milestone| Sport.find(milestone.sport_id).first_parent_name }
      
      #Juntar Works
      @teams_work = Team.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "end DESC, init DESC")
      @trains_work = Trainee.all(:conditions => ['user_id = ?', @user.id], :order => "end DESC, init DESC")
      @results_work = Result.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "date DESC")
      @recognitions_work = Recognition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, false], :order => "date DESC")
      @workExperiences = (@teams_work + @trains_work + @results_work + @recognitions_work)
      @works = Work.all(:conditions => ['user_id = ?', @user.id], :order => "end DESC, init DESC")
      #Juntar Educational
      @educations = Education.all(:conditions => ['user_id = ?', @user.id], :order => "end DESC, init DESC")
      
      #Crear variable para poder crear competition, team, train, result o recognition.
      @recognition = @competition = @result = @team = @train = @trainee = @work = @education = NullObject.new # La clase NullObject está definida al final
      
      # Eventos en los que ha participado
      @events = UserEvent.all(:conditions => ['user_id = ?', @user.id])
      @myevents = []
      @events.each { |event| @myevents.push(Event.select("id, name").find(event.id)) }
    end
    
    #Juntar photos y videos que el usuario ya tiene
    @tags = Tags.all(:conditions => ["type2 = ? AND type1 = ? AND id1 = ?", "Photo", "User", @user.id])
    @tag_photos = []
    unless @tags.empty?
      @tags.each do |tag|
        @tag_photos.push(Photo.find(tag.id2))
      end
    end

    @photos = Photo.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    unless @tag_photos.empty?
      @photos = @photos + @tag_photos
    end

    @videos = Video.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    #Crear variables photo y video para poder subir
    @photo = @user.photos.build if signed_in?
    @video = @user.videos.build if signed_in?
    #Sacando todos los sports
    @sports = Sport.order("parent_id ASC, name ASC").to_json(:only => [ :id, :name, :parent_id ])
    #Creando array de Countries para auto-complete
    @countries = Country.select('name').all.map(&:name)

    @asd = NullObject.new

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
    @user = User.find(params[:id])

    @tags = Tags.all(:conditions => ["type2 = ? AND type1 = ? AND id1 = ?", "Photo", "User", @user.id])
    @tag_photos = []
    unless @tags.empty?
      @tags.each do |tag|
        @tag_photos.push(Photo.find(tag.id2))
      end
    end
    @photos = Photo.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    unless @tag_photos.empty?
      @photos = @photos + @tag_photos
    end
    @videos = Video.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    @photo = @user.photos.build if signed_in?
    @video = @user.videos.build if signed_in?
    
    @events = UserEvent.all(:conditions => ['user_id = ?', current_user.id])
    @myevents = []
    @events.each { |event| @myevents.push(Event.select("id, name").find(event.id)) }
  end

  def auth_email
    @user = User.unscoped.find(params[:id])
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
      sign_in(@user)
    elsif signed_in?
      @user = current_user
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
          work.update_attributes(:company => params[:company], :role => params[:role], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :country_id => params[:country_id], :location => params[:city])
          as_athlete = false
        else
          work = NullObject.new
          as_athlete = true
        end
        
        if params[:sport_id] != ""
          UserSport.new(:user_id => current_user.id, :sport_id => params[:sport_id], :init => params[:init], :end => params[:end]).save unless UserSport.exists?(:user_id => current_user.id, :sport_id => params[:sport_id])
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
          team.update_attributes( :name => params[:team_name], :category => params[:team_category], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :as_athlete => as_athlete, :work_id => work.id, :localization => params[:team_localization] )
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
          competition.update_attributes( :name => params[:competition_name], :organizer => params[:competition_organizer], :place => params[:competition_place], :sport_id => params[:sport_id], :user_id => params[:user_id], :init => params[:init], :end => params[:end], :team_id => team.id, :as_athlete => as_athlete, :work_id => work.id )
          result.update_attributes( :position => params[:result_position], :value => params[:result_value], :var => params[:result_var], :category => params[:result_category], :sport_id => params[:sport_id], :user_id => params[:user_id], :competition_id => competition.id, :date => params[:init], :team_id => team.id, :as_athlete => as_athlete, :work_id => work.id, :best_mark => params[:result_best_mark] )
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
          education.update_attributes(:name => params[:highschool_name], :rank => params[:rank], :gda => params[:gda], :ncaa => params[:ncaa], :country_id => params[:country_id], :location => params[:city], :user_id => params[:user_id], :init => params[:init], :end => params[:end])
        elsif params[:school_name] != ""
          education.update_attributes(:name => params[:school_name], :degree => params[:degree], :country_id => params[:country_id], :location => params[:city], :user_id => params[:user_id], :init => params[:init], :end => params[:end])
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
        when 'user_sport'
          @sport_id = params[:object_id]
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
      elsif @education.id?
        # Ya lleva la fecha
      elsif @competition.id?
        @result = Result.find(:all, :conditions => ['user_id = ? AND sport_id = ? AND competition_id = ?', current_user.id, @sport_id, @competition.id]).first
        @init = @competition.init
        @end = @competition.end
      elsif @team.id?
        @init = @team.init
        @end = @team.end
      else
        user_sport = UserSport.find(:all, :conditions => ['user_id = ? AND sport_id = ?', current_user.id, @sport_id]).first
        @init = user_sport.init
        @end = user_sport.end
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
  
  def highlight
    if params[:object_type] && params[:object_id]
      class_name = params[:object_type].capitalize
      objeto = class_name.constantize.find(params[:object_id])
      
      if objeto.highlight
        objeto.update_attribute(:highlight, 0)
      else
        objeto.update_attribute(:highlight, 1)
      end
      
      respond_to do |format|
        format.json { render :json => { :user_id => params[:id], :highlight => objeto.highlight } }
      end
    else
      redirect_to profile_path(params[:id])
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
        
        if @user.inAdmins?(current_user)
          @user.update_attributes(params[:user])
        else
          redirect_to profile_path(@user) and return
        end
      elsif current_user.isAdmin?
        @user = User.create(params[:user])
        @user.update_attribute(:authentic_email, 1)
        
        if @user.save
          publisher = Publisher.create(:user_id => @user.id, :pub_type => "U")
          
          #Todos siguen a LetsJock por defecto (profile: 1)
          @user.follow!(User.find(1))
          
          if params[:profile_picture] && params[:profile_picture] != "" #Sube la foto de perfil
            url = Photo.upload_file(params[:profile_picture])
            
            if url && url != ""
              Photo.create(:user_id => @user.id, :url => url)
              @user.update_attribute(:profilephotourl, url)
            end
          end
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
    
    if @user.inAdmins?(current_user)
      render "sponsor_new"
    else
      redirect_to profile_path(@user)
    end
  end
  
  def events
    @user = User.find(params[:id])
    
    if @user.isSponsor
      @next_events = Event.find(:all, :conditions => ['user_id = ? AND date >= ?', @user.id, DateTime.now]).to_set.classify { |event| event.date.month }
      @prev_events = Event.find(:all, :conditions => ['user_id = ? AND date < ?', @user.id, DateTime.now])
      
      #Juntar photos y videos que el usuario ya tiene
      @photos = Photo.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
      @videos = Video.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
      
      #Crear variables photo y video para poder subir
      @photo = @user.photos.build if signed_in?
      @video = @user.videos.build if signed_in?
    else
      redirect_to profile_path(@user)
    end
  end
  
  def add_admin
    user = User.find(params[:id])
    
    if user.inAdmins?(current_user)
      if params[:admin_id] && User.exists?(:id => params[:admin_id])
        admin = User.find(params[:admin_id])
        
        unless user.inAdmins?(admin)
          UserAdmin.create(:user_id => user.id, :admin_id => admin.id)
        end
      end
    end
    
    redirect_to profile_path(user)
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
    
    if notification.not_type == "000" 
      redirect_to profile_path( notification.user2_id, { :section => "recommendations", :writer => true, :aux_id => notification.aux_id } )
    elsif notification.not_type == "001"
      redirect_to profile_path( notification.user_id, { :section => "recommendations" } )
    elsif notification.not_type == "003"
      redirect_to profile_path( notification.user2_id )
    elsif notification.not_type == "004"
      redirect_to pictures_path(notification.user2_id, {:callback_id => notification.aux_id})
    elsif notification.not_type == "104" || notification.not_type == "105" || notification.not_type == "106"
      redirect_to event_path( notification.event_id )
    elsif notification.not_type == "200" || notification.not_type == "201" || notification.not_type == "203"
      redirect_to profile_path( notification.aux_id )
    elsif notification.not_type == "999" || notification.not_type == "006"
      redirect_to profile_path( notification.user_id )
    end
  end

  def read_all_notifications
    notifications = Notification.find(:all, :conditions => ["user_id = ?", current_user.id])
    notifications.each do |n|
      if !n.read
        n.update_attributes(:read => true)
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def search
    @queries = Hash.new
    @queries[:basics] = Hash.new
    @queries[:sports] = Hash.new
    @queries[:interests] = Hash.new
    @result = []
    if params[:query]
      @query = params[:query]
      queries = @query.split(" ")
      @result = []
      @queries[:basics] = Hash.new
      queries.each do |qy|
        @result += User.all(:conditions => ["lower(name) LIKE ? OR lower(lastname) LIKE ?", "%#{qy}%".downcase, "%#{qy}%".downcase ]).sort_by(&:id)
        @queries[:basics][:name] = qy
      end
      @result = @result.uniq
    elsif params.include?(:name)
      @result = User.all(:conditions => ["id NOT IN (?)", [1]])
      if params[:name] != ""
        aux = @result
        @result = []
        @queries[:basics][:name] = params[:name]
        aux.each do |user|
          @result.push(user) if user.name && user.name.downcase.include?(params[:name].downcase)
        end
      end
      if params[:lastname] != ""
        aux = @result
        @result = []
        @queries[:basics][:lastname] = params[:lastname]
        aux.each do |user|
          @result.push(user) if user.lastname && user.lastname.downcase.include?(params[:lastname].downcase)
        end
      end
      if params[:age_from] != ""
        aux = @result
        @result = []
        @queries[:basics][:age] = "over " + params[:age_from]
        aux.each do |user|
          @result.push(user) if user.birth && user.age >= params[:age_from].to_i
        end
      end
      if params[:age_to] != ""
        aux = @result
        @result = []
        @queries[:basics][:age] ? @queries[:basics][:age] = @queries[:basics][:age].split(" ")[1] + " - " + params[:age_to] : @queries[:basics][:age] = "below" + params[:age_to]
        aux.each do |user|
          @result.push(user) if user.birth && user.age <= params[:age_to].to_i
        end
      end
      if params[:sport_id] != ""
        aux = @result
        @result = []
        @queries[:sports][:sport] = Sport.find(params[:sport_id]).name
        aux.each do |user|
          @result.push(user) if UserSport.exists?(:sport_id => params[:sport_id], :user_id => user.id)
        end
      end
      if params[:weight_from] != ""
        aux = @result
        @result = []
        @queries[:sports][:weight] = "over " + params[:weight_from]
        aux.each do |user|
          @result.push(user) if user.weight && user.weight >= params[:weight_from].to_i
        end
      end
      if params[:weight_to] != ""
        aux = @result
        @result = []
        @queries[:sports][:weight] ? @queries[:sports][:weight] = @queries[:sports][:weight].split(" ")[1] + " - " + params[:weight_to] : @queries[:sports][:weight] = "below" + params[:weight_to]
        aux.each do |user|
          @result.push(user) if user.weight && user.weight <= params[:weight_to].to_i
        end
      end
      if params[:height_from] != ""
        aux = @result
        @result = []
        @queries[:sports][:height] = "over " + params[:height_from]
        aux.each do |user|
          @result.push(user) if user.height && user.height >= params[:height_from].to_i
        end
      end
      if params[:height_to] != ""
        aux = @result
        @result = []
        @queries[:sports][:height] ? @queries[:sports][:height] = @queries[:sports][:height].split(" ")[1] + " - " + params[:height_to] : @queries[:sports][:height] = "below" + params[:height_to]
        aux.each do |user|
          @result.push(user) if user.height && user.height <= params[:height_to].to_i
        end
      end
      if params[:institution] != ""
        aux = @result
        @result = []
        @queries[:basics][:institution] = "only institutions" if params[:institution]
        aux.each do |user|
          @result.push(user) if (params[:institution] && user.isSponsor) || (!params[:institution] && !user.isSponsor)
        end
      end
      if params[:male] || params[:female]
        aux = @result
        @result = []
        @queries[:basics][:genre] = "male" if params[:male]
        @queries[:basics][:genre] = "female" if params[:female]
        @queries[:basics][:genre] = "male and female" if params[:male] && params[:female]
        aux.each do |user|
          @result.push(user) if user.gender && ((user.gender.downcase == "m" && params[:male])||(user.gender.downcase == "f" && params[:female]))
        end
      end
    end
    @sports_list = Sport.select('name').all.map(&:name)
  end

  def forgotten_password

  end

  def new_password_request
    if User.unscoped.exists?(:email => params[:email])
      @user = User.unscoped.find_by_email(params[:email])
      UserMailer.new_password(@user).deliver
    end
    flash[:success] = "An email with further instructions has been sent to " + params[:email]
    redirect_to root_url
  end

  def confirmed_new_password
    if User.unscoped.exists?(:email_token => params[:token])
      @user = User.unscoped.find_by_email_token(params[:token])
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
    if User.unscoped.exists?(:email_token => params[:token])
        if params[:password] == params[:password_confirmation]
          @user = User.unscoped.find_by_email_token( params[:token])
          if @user.update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation])
            flash[:success] = "Your password has been changed."
            redirect_to root_url
          end
        else
          flash[:error] = "Passwords did not match."
          redirect_to confirmed_new_password_path(params[:token])
        end
    else
    end
  end

  def send_mail_auth
    if params[:email] && User.unscoped.exists?(:email => params[:email].downcase)
      user = User.unscoped.find_by_email(params[:email].downcase)
      unless user.authentic_email
        UserMailer.registration_confirmation(user).deliver
      end
    end
    flash[:success] = "The registration email has been sent again."
    redirect_to root_url
  end
  
  def follow_letsjock
    if signed_in? && current_user.id == 1
      #User.unscoped.find(:all, :conditions => ["id NOT IN (?) AND id != ?", current_user.followers, current_user.id] ).each do |user|
      #  user.follow!(current_user)
      #end
      
      # Perfil invitado sigue a sus seguidores
      invitado = User.find(21)
      
      invitado.followed_users.each do |user|
        user.follow!(invitado) unless user.following?(invitado)
      end
      
    end
    
    redirect_to news_path
  end
  
  def typeahead
    if params[:type] && params[:query] != ""
      like = []
      
      case params[:type]
        when 'User'
          params[:query].split(" ").each do |qy|
            like.push("lower(name) LIKE '%" + qy.downcase + "%' OR lower(lastname) LIKE '%" + qy.downcase + "%'")
          end
          
          users = User.select("id, name, lastname").where("(" + like.join(" OR ") + " ) AND isSponsor = 0").uniq.order("name").limit(8)
        when 'Institution'
          params[:query].split(" ").each do |qy|
            like.push("lower(name) LIKE '%" + qy.downcase + "%'")
          end
          
          users = User.select("id, name, '' as lastname").where("( "+ like.join(" OR ") + " ) AND isSponsor = 1").uniq.order("name").limit(8)
      end
      
      respond_to do |format|
        format.json { render :json => { :options => users } }
      end
    else
      redirect_to news_path
    end
  end
  
  def like
    if params[:object_id] !="" && params[:object_type] != ""
      if Like.exists?(:user_id => current_user.id, :object_id => params[:object_id], :object_type => params[:object_type])
        likes = Like.where(:user_id => current_user.id, :object_id => params[:object_id], :object_type => params[:object_type]).first.destroy
      else
        Like.create(:user_id => current_user.id, :object_id => params[:object_id], :object_type => params[:object_type])
      end
    end
    
    respond_to do |format|
      format.js { render :json => { :user_id => current_user.id } }
    end
  end
  
  def is_liked?
    liked = false
    
    if params[:object_id] !="" && params[:object_type] != ""
      liked = Like.exists?(:user_id => current_user.id, :object_id => params[:object_id], :object_type => params[:object_type])
    end
    
    respond_to do |format|
      format.js { render :json => { :liked => liked } }
    end
  end

  def certify
    @user = User.find(params[:id])

    if(@user.certified)
      @user.update_attribute(:certified, false)
    else
      @user.update_attribute(:certified, true)
    end

    respond_to do |format|
      format.js
    end
  end
  
  def compare
	@users_array = User.find(:all, :conditions => ["isSponsor = ?", false]).map{|p| {:label=>p.full_name, :value=>p.id, :sport=>p.sport_show, :image=>p.profilepic_route}}.to_json.html_safe
  end

  def comparison
    @users_array = User.find(:all, :conditions => ["isSponsor = ?", false]).map{|p| {:label=>p.full_name, :value=>p.id, :sport=>p.sport_show, :image=>p.profilepic_route}}.to_json.html_safe

    if params[:user1_id] && params[:user1_id] != ""
      @user1 = User.find(params[:user1_id])
      @train1 = Train.find(:all, :conditions => ["user_id = ?", @user1.id])
      @award1 = Recognition.find(:all, :conditions => ["user_id = ?", @user1.id])
      @team1 = Team.find(:all, :conditions => ["user_id = ?", @user1.id])
      @school1 = Education.find(:first, :conditions => ["user_id = ?", @user1.id])

      @tags1 = Tags.all(:conditions => ["type2 = ? AND type1 = ? AND id1 = ?", "Photo", "User", @user1.id])
      @tag_photos1 = []
      unless @tags1.empty?
        @tags1.each do |tag|
          @tag_photos1.push(Photo.find(tag.id2))
        end
      end
      @photos1 = Photo.all(:conditions => ['user_id = ?', @user1.id], :order => "id desc")
      unless @tag_photos1.empty?
        @photos1 = @photos1 + @tag_photos1
      end
      @videos1 = Video.all(:conditions => ['user_id = ?', @user1.id], :order => "id desc")
    end

    if params[:user2_id] && params[:user2_id] != ""
      @user2 = User.find(params[:user2_id])
      @train2 = Train.find(:all, :conditions => ["user_id = ?", @user2.id])
      @award2 = Recognition.find(:all, :conditions => ["user_id = ?", @user2.id])
      @team2 = Team.find(:all, :conditions => ["user_id = ?", @user2.id])
      @school2 = Education.find(:first, :conditions => ["user_id = ?", @user2.id])

      @tags2 = Tags.all(:conditions => ["type2 = ? AND type1 = ? AND id1 = ?", "Photo", "User", @user2.id])
      @tag_photos2 = []
      unless @tags2.empty?
        @tags2.each do |tag|
          @tag_photos2.push(Photo.find(tag.id2))
        end
      end
      @photos2 = Photo.all(:conditions => ['user_id = ?', @user2.id], :order => "id desc")
      unless @tag_photos2.empty?
        @photos2 = @photos2 + @tag_photos2
      end
      @videos2 = Video.all(:conditions => ['user_id = ?', @user2.id], :order => "id desc")
    end

    respond_to do |format|
		format.html      
    end
  end

  def add_comment
    if params[:object_id] !="" && params[:object_type] != "" && params[:writer_id] != "" && params[:comment] != ""
      comment = Comment.new(:user_id => params[:writer_id], :object_id => params[:object_id], :object_type => params[:object_type])
      
      # Pasar urls a su formato HTML
      comment.comment = params[:comment].gsub( %r{http://[^\s<]+} ) do |url|
          "<a href='#{url}'>#{url}</a>"
      end
      
      if comment.save
        if params[:object_type] == "Post"
          post = Post.find(params[:object_id])
          user = post.user
          
          # Si existe evento es act_type 033 (User comment in event) sino 004 (user commented a Y's post)
          Activity.create(:publisher_id => Publisher.find_by_user_id( params[:writer_id] ).id, :post_id => post.id, :event_id => post.event_id, :act_type => post.event_id ? "033" : "004")
          
          # Manda notificaciones a todos los administradores
          if user.isSponsor && user.admins.any?
            user.admins.each do |admin|
              Notification.create( :user_id => admin.id, :user2_id => params[:writer_id], :event_id => post.event_id, :aux_id => user.id, :read => false, :not_type => post.event_id ? "106" : "201" )
            end
          end
        end
        
      end 
    end
    
    respond_to do |format|
      format.js { render :json => { :user_id => params[:writer_id], :comment_id => comment ? comment.id : nil } }
    end
  end

  def add_tag

    tagsUser = Tags.select("id1").find(:all, :conditions => ["type1 = ? AND id2 = ? AND type2 = ?", "User", params[:tags][:photo_id], "Photo"])
    tagsEvent = Tags.select("id1").find(:all, :conditions => ["type1 = ? AND id2 = ? AND type2 = ?", "Event", params[:tags][:photo_id], "Photo"])
    tagsUserArray = params[:tags][:users]
    tagsEventArray = params[:tags][:events]


    if !tagsUser.empty?
      tagsUser.each do |tag|
        if !tagsUserArray.blank?
          res = tagsUserArray.reject! {|user| user.to_i == tag.id1}
        else
          res = nil
        end

        if(res == nil)
          Tags.find(:all, :conditions => ["id1 = ? AND type1 = ? AND id2 = ? AND type2 = ?", tag.id1, "User", params[:tags][:photo_id], "Photo"]).each do |us|
            us.destroy
          end
        end
      end
    end
    if !tagsUserArray.blank?
      tagsUserArray.each do |tag|
        Tags.create(:id1 => tag, :type1 => "User", :id2 => params[:tags][:photo_id], :type2 => "Photo")
        Notification.create(:user_id => tag, :user2_id => params[:tags][:user_id], :aux_id => params[:tags][:photo_id], :aux_type => "Photo", :read => false, :not_type => "004")
      end
    end


    if !tagsEvent.empty?
      tagsEvent.each do |tag|
        if !tagsEventArray.blank?
          res = tagsEventArray.reject! {|event| event.to_i == tag.id1}
        else
          res = nil
        end

        if(res == nil)
          Tags.find(:all, :conditions => ["id1 = ? AND type1 = ? AND id2 = ? AND type2 = ?", tag.id1, "Event", params[:tags][:photo_id], "Photo"]).each do |ev|
            ev.destroy
          end
        end
      end
    end
    if !tagsEventArray.blank?
      tagsEventArray.each do |tag|
        Tags.create(:id1 => tag, :type1 => "Event", :id2 => params[:tags][:photo_id], :type2 => "Photo")
      end
    end



    #3 condiciones: doble existencia, existencia en el servidor y existencia en params[:tags][:users]
    #Recorrer el servidor, si el tag está en el array, lo saco. Si no está, lo elimino (de la bd).
    #Si array queda con elementos, estos elementos los creo.
    #arr.delete_if (|item| item == 'id')

    redirect_to pictures_path(User.find(params[:tags][:actual_user_id]), {:callback_id => params[:tags][:photo_id]})

  end

  def add_iam_tag
    tagsIam =  Tags.select("id1").find(:all, :conditions => ["type1 = ? AND id2 = ? AND type2 = ?", "GLOBAL_TAGS_IAM", params[:tags][:user_id], "User"])
    tagsIamArray = params[:tags][:iam]

    if !tagsIam.empty?
      tagsIam.each do |tag|
        if !tagsIamArray.blank?
          res = tagsIamArray.reject! {|iam| iam.to_i == tag.id1}
        else
          res = nil
        end

        if(res == nil)
          Tags.delete_all("id1 = #{tag.id1} AND type1 = 'GLOBAL_TAGS_IAM' AND id2 = #{params[:tags][:user_id]} AND type2 = 'User'")
        end
      end
    end
    if !tagsIamArray.blank?
      tagsIamArray.each do |tag|
        Tags.create(:id1 => tag, :type1 => "GLOBAL_TAGS_IAM", :id2 => params[:tags][:user_id], :type2 => "User")
      end
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render :json => { :status => true } }
    end
  end

  def add_user_tag

    tagsLooking =  Tags.select("id1").find(:all, :conditions => ["type1 = ? AND id2 = ? AND type2 = ?", "GLOBAL_TAGS_LOOKING", params[:tags][:user_id], "User"])
    tagsInterest =  Tags.select("id1").find(:all, :conditions => ["type1 = ? AND id2 = ? AND type2 = ?", "GLOBAL_TAGS_INTEREST", params[:tags][:user_id], "User"])
    tagsDivision =  Tags.select("id1").find(:all, :conditions => ["type1 = ? AND id2 = ? AND type2 = ?", "GLOBAL_TAGS_DIVISION", params[:tags][:user_id], "User"])

    tagsLookingArray = params[:tags][:looking]
    tagsInterestArray = params[:tags][:interest]
    tagsDivisionArray = params[:tags][:division]

    if !tagsLooking.empty?
      tagsLooking.each do |tag|
        if !tagsLookingArray.blank?
          res = tagsLookingArray.reject! {|look| look.to_i == tag.id1}
        else
          res = nil
        end

        if(res == nil)
          Tags.delete_all("id1 = #{tag.id1} AND type1 = 'GLOBAL_TAGS_LOOKING' AND id2 = #{params[:tags][:user_id]} AND type2 = 'User'")
        end
      end
    end
    if !tagsLookingArray.blank?
      tagsLookingArray.each do |tag|
        Tags.create(:id1 => tag, :type1 => "GLOBAL_TAGS_LOOKING", :id2 => params[:tags][:user_id], :type2 => "User")
      end
    end

    if !tagsInterest.empty?
      tagsInterest.each do |tag|
        if !tagsInterestArray.blank?
          res = tagsInterestArray.reject! {|inte| inte.to_i == tag.id1}
        else
          res = nil
        end

        if(res == nil)
          Tags.delete_all("id1 = #{tag.id1} AND type1 = 'GLOBAL_TAGS_INTEREST' AND id2 = #{params[:tags][:user_id]} AND type2 = 'User'")
        end
      end
    end
    if !tagsInterestArray.blank?
      tagsInterestArray.each do |tag|
        Tags.create(:id1 => tag, :type1 => "GLOBAL_TAGS_INTEREST", :id2 => params[:tags][:user_id], :type2 => "User")
      end
    end

    if !tagsDivision.empty?
      tagsDivision.each do |tag|
        if !tagsDivisionArray.blank?
          res = tagsDivisionArray.reject! {|div| div.to_i == tag.id1}
        else
          res = nil
        end

        if(res == nil)
          Tags.delete_all("id1 = #{tag.id1} AND type1 = 'GLOBAL_TAGS_DIVISION' AND id2 = #{params[:tags][:user_id]} AND type2 = 'User'")
        end
      end
    end
    if !tagsDivisionArray.blank?
      tagsDivisionArray.each do |tag|
        Tags.create(:id1 => tag, :type1 => "GLOBAL_TAGS_DIVISION", :id2 => params[:tags][:user_id], :type2 => "User")
      end
    end

    redirect_to request.referer
  end

  def add_sport_profile
    @index = params[:index]
    @sport_id = params[:sport_id]
    respond_to do |format|
      format.js
    end
  end
  
  def ask_recommendation
    if params[:writer_id] != "" || params[:writer_email] != ""
      # Crea la recomendación con el status en 0
      recommendation = Recommendation.create(:user_id => current_user.id, :writer_id => params[:writer_id] ? params[:writer_id] : nil, :writer_type => params[:writer_type], :sport_id => params[:sport_id] ? params[:sport_id] : nil, :status => 0)
      
      UserMailer.ask_recommendation({ :id => recommendation.id, :name => current_user.full_name, :email => params[:writer_email] != "" ? params[:writer_email] : User.select("email").find(params[:writer_id]).email, :message => params[:message] }).deliver
      
      if params[:writer_id] != "" && User.exists?(params[:writer_id])
        Notification.create( :user_id => params[:writer_id], :user2_id => current_user.id, :read => false, :not_type => "000", :aux_id => recommendation.id )
      end
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render :json => { :status => true } }
    end
  end
  
  def write_recommendation
    if signed_in?
      # Follow y followed, sino no va a poder ver el perfil
      if Recommendation.exists?(params[:id])
        recommendation = Recommendation.find(params[:id])
        recommendation.update_attribute(:writer_id, current_user.id)
        user = User.find(recommendation.user_id)
        
        unless user.following?(current_user)
          user.follow!(current_user)
        end
        
        unless Notification.exists?(:user_id => current_user.id, :user2_id => params[:id], :not_type => "000")
          Notification.create( :user_id => current_user.id, :user2_id => recommendation.user_id, :read => false, :not_type => "000", :aux_id => recommendation.id )
        end
        
        redirect_to profile_path(user, { :section => "recommendations", :writer => true, :aux_id => recommendation.id })
      else
        session[:redirected_by] = nil
        redirect_to news_path
      end
    else
      session[:redirected_by] = "/write_recommendation/" + params[:id]
      flash[:error] = "You must be logged in."
      redirect_to root_path and return
    end
  end

  def create_recommendation
    if params[:recommendation_id] != "" && params[:content] && params[:id] != current_user.id
      recommendation = Recommendation.find(params[:recommendation_id])
      recommendation.update_attributes(:content => params[:content], :status => 1)
      
      Notification.create( :user_id => recommendation.user_id, :user2_id => current_user.id, :read => false, :not_type => "001", :aux_id => recommendation.id )
      
      UserMailer.new_recommendation({ :id => recommendation.user_id, :name => current_user.full_name, :email => User.select("email").find(recommendation.user_id).email }).deliver
    end
    
    redirect_to profile_path(params[:id])
  end
  
  def ask_sponsoring
    if params[:user_id] != "" && params[:sponsor_id] != ""
      user = User.find(params[:user_id])
      
      if user.id == current_user.id # Si el usuario solicita manda la notificacion a todos los admins
        sponsor = User.find(params[:sponsor_id])
        
        # Manda notificaciones a todos los administradores
        if sponsor.isSponsor && sponsor.admins.any?
          sponsor.admins.each do |admin|
            Notification.create(:user_id => admin.id, :user2_id => params[:user_id], :read => false, :not_type => "202", :aux_id => sponsor.id)
          end
        end
      elsif user.inAdmins?(current_user)
        Notification.create(:user_id => params[:sponsor_id], :user2_id => params[:user_id], :read => false, :not_type => "006")
      end
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render :json => { :status => true } }
    end
  end
  
  # def render_compare
  #	 render "users/compare_partial"
  # end
  
  def confirm_sponsoring
    if params[:notification_id] != "" && params[:confirm_action] != ""
      notification = Notification.find(params[:notification_id])
      notification.update_attributes(:read => true) #Debería marcar como leídos todos
      
      if params[:confirm_action] == "confirm"
        if notification.not_type == "006" && notification.user_id == current_user.id
          UserSponsor.create(:user_id => current_user.id, :sponsor_id => notification.user2_id)
          
          sponsor = User.find(notification.user2_id)
          
          # Manda notificaciones a todos los administradores
          if sponsor.isSponsor && sponsor.admins.any?
            sponsor.admins.each do |admin|
              Notification.create(:user_id => admin.id, :user2_id => current_user.id, :read => false, :not_type => "203", :aux_id => sponsor.id)
            end
          end
        elsif notification.not_type == "202"
          sponsor = User.find(notification.aux_id)
          
          if sponsor.inAdmins?(current_user)
            UserSponsor.create(:user_id => notification.user_id, :sponsor_id => sponsor.id)
            Notification.create(:user_id => notification.user_id, :user2_id => sponsor.id, :read => false, :not_type => "007")
          end
        end
      end
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render :json => { :status => true } }
    end
  end
  
  def add_agent
    if params[:user_id] && params[:user_id] == current_user.id.to_s
      agent = Agent.exists?(params[:agent_id]) ? Agent.find(params[:agent_id]) : Agent.new
      
      agent.update_attributes(:user_id => params[:user_id], :name => params[:name], :lastname => params[:lastname], :email => params[:email], :phone => params[:phone])
    end
    
    redirect_to request.referer
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
