class TraineesController < ApplicationController

  def create
    @user = User.find(params[:trainee][:user_id])
    if signed_in? && current_user.id == @user.id
      @trainee = @user.trainees.build(params[:trainee])
      if @trainee.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def update
    @trainee = Trainee.find(params[:id])
    if signed_in? && current_user.id == @trainee.user_id
      respond_to do |format|
        if @trainee.update_attributes(params[:trainee])
          format.html { redirect_to '/profile/' + @trainee.user_id.to_s, notice: 'Train was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @trainee.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def destroy
    @trainee = Trainee.find(params[:id])
    @user = User.find(@trainee.user_id)
    if signed_in? && current_user.id == @user.id
      @trainee.destroy

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
