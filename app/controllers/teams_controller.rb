class TeamsController < ApplicationController

  def create
    @user = User.find(params[:team][:user_id])
    @team = @user.teams.build(params[:team])
    if @team.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

end
