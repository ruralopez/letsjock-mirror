class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @date = Time.new
    if params[:page]
      params[:page].to_i.times do |i|
        @date = @date.next_week
        if i == params[:page].to_i - 1
          @date = @date.tomorrow
        end
      end
    end
    @events = Event.all.sort_by(&:date).reverse
    @nextevents = Event.all(:conditions => ["date >= ?", Time.new])
    @previousevents = Event.all(:conditions => ["date < ?", Time.new]).sort_by(&:date).reverse
    @sports_list = Sport.select('name').all.map(&:name)
    @filters = Event.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @creator = User.find(@event.user_id)
    @event_admins = EventAdmin.all(:conditions => ["event_id = ?", params[:id]])
    @post = @event.posts.build if signed_in? && @event.admin?(current_user)
    @posts = Post.all(:conditions => ["event_id = ?", @event.id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @prueba = Event.first
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    if signed_in? && current_user.id == @event.user_id
      respond_to do |format|
        if @event.save
          publisher = Publisher.new(:event_id => @event.id, :pub_type => "E")
          eventadmin = EventAdmin.new(:user_id => @event.user_id, :event_id => @event.id)
          if eventadmin.save && publisher.save
            Activity.new(:publisher_id => Publisher.find_by_user_id(current_user.id).id, :event_id => @event.id, :act_type => "031").save
            format.html { redirect_to @event, notice: 'Event was successfully created.' }
            format.json { render json: @event, status: :created, location: @event }
          end
        else
          format.html { render action: "new" }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    if signed_in? && current_user.id == @event.user_id
      respond_to do |format|
        if @event.update_attributes(params[:event])
          Activity.new(:publisher_id => Publisher.find_by_event_id(@event.id).id, :act_type => "100").save
          userevents = UserEvent.all(:conditions => ["event_id = ?", @event.id])
          userevents.each do |userevent|
          Notification.new(:user_id => userevent.user_id, :event_id => @event.id, :read => false, :not_type => "104").save
          end
          format.html { redirect_to @event, notice: 'Event was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    if signed_in? && current_user.id == @event.user_id
      @event.destroy

      respond_to do |format|
        format.html { redirect_to events_url }
        format.json { head :no_content }
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def join
    userevent = UserEvent.new(:user_id => current_user.id, :event_id => params[:id])
    subscription = Subscription.new(:user_id => current_user.id, :publisher_id => Publisher.find_by_event_id(params[:id]).id)
    if userevent.save && subscription.save
      Activity.new(:publisher_id => Publisher.find_by_user_id(current_user.id).id, :event_id => params[:id], :act_type => "030").save
      respond_to do |format|
        format.html { redirect_to root_url + 'events/' + params[:id].to_s }
        format.js { render :nothing => true }
      end
    end
  end

  def new_admin
    if User.find_by_email(params[:email])
      @user = User.find_by_email(params[:email])
      eventadmin = EventAdmin.new(:user_id => @user.id, :event_id => params[:id])
      if eventadmin.save
        Activity.new(:publisher_id => Publisher.find_by_event_id(params[:id]).id, :user_id => @user.id, :act_type => "102").save
        flash[:success] = @user.full_name + " has been granted with administration privileges."
        respond_to do |format|
          format.html { redirect_to event_path(params[:id]) }
          format.js { render :nothing => true }
        end
      end
    else
      flash[:error] = "The specified user does not exist."
      redirect_to event_path(params[:id])
    end
  end

end
