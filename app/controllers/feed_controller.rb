class FeedController < ApplicationController

  def index
    if signed_in?
      ids = Subscription.joins(:publisher => :user).where("subscriptions.user_id = ? AND users.authentic_email = 1", current_user.id).collect(&:publisher_id)
      @news = Activity.all(:conditions => ["publisher_id IN (?)", ids], :order => "created_at desc", :limit => 50)
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end
  
end
