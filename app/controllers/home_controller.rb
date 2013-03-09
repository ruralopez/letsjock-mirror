class HomeController < ApplicationController

  def index
    unless signed_in?
      @user = User.new
      @home = true
    else
      redirect_to news_path
    end
  end

end