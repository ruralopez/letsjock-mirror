class HomeController < ApplicationController

  def index
    @user = User.new
    @home = true
  end

end