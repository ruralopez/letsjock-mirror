class Event < ActiveRecord::Base
  has_many :user_events
  has_many :users, :through => :user_events

  attr_accessible :date, :description, :name, :imageurl, :user_id

  def assistants
    @userevents = UserEvent.all(:conditions => ['event_id = ?', self.id])
    @userids = Array.new
    @userevents.each do |userevent|
      @userids.push(userevent.user_id)
    end
    User.find_all_by_id(@userids)
  end

end
