class FeedController < ApplicationController
  require 'will_paginate/array'
  def index
    if signed_in?
      # Si viene con un redirect
      if session[:redirected_by] && session[:redirected_by] != ""
        tmp = session[:redirected_by]
        session[:redirected_by] = nil
        redirect_to tmp and return
      end
      
      publishers_ids = Subscription.joins(:publisher => :user).where("subscriptions.user_id = ? AND users.authentic_email = 1", current_user.id).collect(&:publisher_id)
      others_ids = Subscription.joins(:publisher).where("subscriptions.user_id = ? AND publishers.user_id IS NULL", current_user.id).collect(&:publisher_id)
      ids = publishers_ids + others_ids
      
      @news = Activity.all(:conditions => ["publisher_id IN (?)", ids], :order => "created_at desc").paginate(:page => params[:page], :per_page => 15)
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_url
    end
  end
  
end
