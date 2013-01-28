class TeamsController < ApplicationController

  def create
    @user = User.find(params[:team][:user_id])
    @team = @user.teams.build(params[:team])
    if @team.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

  def update
    @team = Team.find(params[:id])
    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to '/profile/' + @team.user_id.to_s, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

end
