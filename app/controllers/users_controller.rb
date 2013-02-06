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
    @user = User.new(:email => params[:email], :password => params[:password], :name => params[:name], :lastname => params[:lastname])

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to '/profile/' + @user.id.to_s, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
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
    if signed_in? && current_user.id == @user.id
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
    #Juntar competitions, teams, trains, results y recognitions como athlete experiences
    @competitions = Competition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "init desc")
    @teams = Team.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "init desc")
    @trains = Train.all(:conditions => ['user_id = ?', @user.id], :order => "init desc")
    @results = Result.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "date desc")
    @recognitions = Recognition.all(:conditions => ['user_id = ? AND as_athlete = ?', @user.id, true], :order => "date desc")
    @athleteExperiences = (@competitions + @teams + @trains + @results + @recognitions).sort_by(&:init).reverse
    #Juntar Works
    @works = Work.all(:conditions => ['user_id = ?', @user.id])
    #Juntar Educational
    @educations = Education.all(:condition => ['user_id = ?', @user.id])
    #Crear variable para poder crear competition, team, train, result o recognition.
    #@competition = @user.competitions.build if signed_in?
    #@team = @user.teams.build if signed_in?
    #@train = @user.trains.build if signed_in?
    #@result = @user.results.build if signed_in?
    #@recognition = @user.recognitions.build if signed_in?
    #Juntar photos y videos que el usuario ya tiene
    @photos = Photo.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    @videos = Video.all(:conditions => ['user_id = ?', @user.id], :order => "id desc")
    #Crear variables photo y video para poder subir
    @photo = @user.photos.build if signed_in?
    @video = @user.videos.build if signed_in?
    #Sacando todos los sports para los botones de agregar entrada
    @sports = Sport.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

end
