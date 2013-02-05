class EducationsController < ApplicationController

  def create
    @user = User.find(params[:education][:user_id])
    if signed_in? && current_user.id == @user.id
      @education = @user.educations.build(params[:education])
      if @education.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end

  end

  def update
    @education = Education.find(params[:id])
    if signed_in? && current_user.id == @education.user_id
      respond_to do |format|
        if @education.update_attributes(params[:education])
          format.html { redirect_to '/profile/' + @education.user_id.to_s, notice: 'Education was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @education.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end

  end

  def destroy
    @education = Education.find(params[:id])
    @user = User.find(@education.user_id)
    if signed_in? && current_user.id == @user.id
      @education.destroy

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