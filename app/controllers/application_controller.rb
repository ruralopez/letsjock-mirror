class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :get_notifications
  def get_notifications
    if signed_in?
      @global_notifications = Notification.all(:conditions => ["user_id = ?", current_user.id], :order => "created_at desc", :limit => 30)
    end
  end
end
