class TeamsController < ApplicationController

  def create
    @user = User.find(params[:team][:user_id])
    if signed_in? && current_user.id == @user.id
      @team = @user.teams.build(params[:team])
      if @team.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def update
    @team = Team.find(params[:id])
    if signed_in? && current_user.id == @team.user_id
      respond_to do |format|
        if @team.update_attributes(params[:team])
          format.html { redirect_to '/profile/' + @team.user_id.to_s, notice: 'Team was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @user = User.find(@team.user_id)
    if signed_in? && current_user.id == @user.id
      @team.destroy

      respond_to do |format|
        format.html { redirect_to @user }
        format.json { head :no_content }
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

end
