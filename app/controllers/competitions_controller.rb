class CompetitionsController < ApplicationController

  def create
    @user = User.find(params[:competition][:user_id])
    if signed_in? && current_user.id == @user.id
      @competition = @user.competitions.build(params[:competition])
      if @competition.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end

  end

  def update
    @competition = Competition.find(params[:id])
    if signed_in? && current_user.id == @competition.user_id
      respond_to do |format|
        if @competition.update_attributes(params[:competition])
          format.html { redirect_to '/profile/' + @competition.user_id.to_s, :notice => 'Competition was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @competition.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end

  end

  def destroy
    @competition = Competition.find(params[:id])
    @user = User.find(@competition.user_id)
    if signed_in? && current_user.id == @user.id
      @competition.destroy

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
