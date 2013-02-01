class WorksController < ApplicationController

  def create
    @work = User.find(params[:work][:user_id])
    if signed_in? && current_user.id == @user.id
      @work = @user.works.build(params[:work])
      if @work.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def update
    @work = Work.find(params[:id])
    if signed_in? && current_user.id == @work.user_id
      respond_to do |format|
        if @work.update_attributes(params[:work])
          format.html { redirect_to '/profile/' + @work.user_id.to_s, notice: 'Work was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @work.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def destroy
    @work = Work.find(params[:id])
    @user = User.find(@work.user_id)
    if signed_in? && current_user.id == @user.id
      @work.destroy

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
