class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :get_notifications
  def get_notifications
    if signed_in?
      limit = Notification.where(:user_id => current_user.id, :read => false).count < 5 ? 5: Notification.where(:user_id => current_user.id, :read => false).count
      @global_notifications = Notification.all(:conditions => ["user_id = ?", current_user.id], :order => "created_at desc").paginate(:page => params[:page], :per_page => limit)
    end
  end
end
