class CompetitionsController < ApplicationController

  def create
    @user = User.find(params[:competition][:user_id])
    @competition = @user.competitions.build(params[:competition])
    if @competition.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

end
