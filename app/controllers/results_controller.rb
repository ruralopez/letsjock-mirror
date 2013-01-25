class ResultsController < ApplicationController

  def create
    @user = User.find(params[:result][:user_id])
    @result = @user.results.build(params[:result])
    if @result.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

end
