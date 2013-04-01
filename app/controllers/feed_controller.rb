class FeedController < ApplicationController

  def index

    if signed_in?
    ids = Subscription.all(:conditions => ["user_id = ?", current_user.id]).collect(&:publisher_id)
    @news = Activity.all(:conditions => ["publisher_id IN (?)", ids], :order => "created_at desc")

    else
    flash[:error] = "You must be logged in."
    sign_out
    redirect_to signin_path

    end

  end

end
