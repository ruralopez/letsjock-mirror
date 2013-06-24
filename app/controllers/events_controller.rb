class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @date = Time.new
    if params[:page]
      if params[:page].to_i > 0
        @date += params[:page].to_i.weeks
      else
        @date -= params[:page].to_i.abs.weeks
      end
    else
      params[:page] = 0
    end
    @events = Event.all.sort_by(&:date).reverse
    @nextevents = Event.all(:conditions => ["date >= ?", Time.new])
    @previousevents = Event.all(:conditions => ["date < ?", Time.new]).sort_by(&:date).reverse
    @sports_list = Sport.select('name').all.map(&:name)
    @filters = Event.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    
    @tags = Tags.select("id2").all(:conditions => ["type2 = ? AND type1 = ? AND id1 = ?", "Photo", "Event", @event.id])
    @photos = []
    unless @tags.empty?
      @tags.each do |tag|
        @photos.push(Photo.find(tag.id2))
      end
    end
    
    if signed_in?
      userstats = Stat.all(:conditions => ["user_id = ? AND type = ? AND info = ? AND created_at between ? AND ?", current_user.id, "Event", @event.id, Time.zone.now.beginning_of_day, Time.zone.now.end_of_day])
      if userstats.empty?
        Stat.new(:user_id => current_user.id, :type => "Event", :info => @event.id).save
      end
    end
    
    @user = User.find(@event.user_id)
    @event_admins = EventAdmin.all(:conditions => ["event_id = ?", params[:id]])
    @post = @event.posts.build if signed_in? && ( @event.admin?(current_user) || @user.inAdmins?(current_user) )
    @posts = Post.all(:conditions => ["event_id = ?", @event.id], :order => "created_at DESC")
    ids = SponsorsEvent.where(:event_id => @event.id).collect(&:user_id)
    @sponsors = User.all(:conditions => ["id IN (?)", ids])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @user = User.find(params[:id])
    
    if signed_in? && @user.inAdmins?(current_user)
      @event = Event.new
      
      @user = User.find(params[:id])
      #@sponsors = User.where(:isSponsor => true).collect(&:name)
      @sponsors = User.where(:isSponsor => true).collect { |sponsor| [sponsor.name, sponsor.id] }
      
      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @event }
      end
    else
      redirect_to news_path
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    @sponsors = User.where(:isSponsor => true).collect { |sponsor| [sponsor.name, sponsor.id] }
    render "new"
  end

  # POST /events
  # POST /events.json
  def create
    if signed_in? && current_user.isAdmin?
      @event = Event.new(params[:event])
      respond_to do |format|
        if @event.save
          publisher = Publisher.new(:event_id => @event.id, :pub_type => "E")
          eventadmin = EventAdmin.new(:user_id => current_user.id, :event_id => @event.id)
          eventuser = UserEvent.new(:user_id => current_user.id, :event_id => @event.id)
          
          if eventadmin.save && publisher.save && eventuser.save
            Subscription.new(:user_id => current_user.id, :publisher_id => publisher.id).save
            Activity.new(:publisher_id => Publisher.find_by_user_id(@event.user_id).id, :event_id => @event.id, :act_type => "031").save

            params[:sponsors].each_with_index do |sponsor, index|
              if sponsor[1][:id] != ""
                SponsorsEvent.new(:user_id => sponsor[1][:id], :event_id => @event.id, :category => sponsor[1][:category]).save
              end
            end

            if params[:profile_picture] && params[:profile_picture] != ""
              url = Photo.upload_file(params[:profile_picture])
              @event.update_attribute(:imageurl, url) if url != ""
            end
            
            format.html { redirect_to @event, :notice => 'Event was successfully created.' }
            format.json { render :json => @event, :status => :created, :location => @event }
          end
        else
          format.html { render :action => "new" }
          format.json { render :json => @event.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      redirect_to root_path
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    if signed_in? && current_user.isAdmin?
      @event = Event.find(params[:id])
      
      respond_to do |format|
        if @event.update_attributes(params[:event])
          Activity.new(:publisher_id => Publisher.find_by_event_id(@event.id).id, :act_type => "100").save
          userevents = UserEvent.all(:conditions => ["event_id = ?", @event.id])
          
          userevents.each do |userevent|
            Notification.new(:user_id => userevent.user_id, :event_id => @event.id, :read => false, :not_type => "104").save
          end
          
          format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @event.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      redirect_to root_path
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
        format.html { redirect_to Event.find(params[:id]) }
        format.js
      end
    end
  end

  def disjoin
    if signed_in?
      userevent = UserEvent.first(:conditions => ["user_id = ? AND event_id = ?", current_user.id, params[:id]])
      userevent.destroy
      subscription = Subscription.first(:conditions => ["user_id = ? AND publisher_id = ?", current_user.id, Publisher.find_by_event_id(params[:id]).id])
      subscription.destroy
        respond_to do |format|
          format.html { redirect_to Event.find(params[:id]) }
          format.js
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

  def add_sponsor
    @index = params[:index]
    @category = params[:category]
    #@sponsors = User.where(:isSponsor => true).collect(&:name)
    @sponsors = User.where(:isSponsor => true).collect { |sponsor| [sponsor.name, sponsor.id] }
    respond_to do |format|
      format.js
    end
  end

end
