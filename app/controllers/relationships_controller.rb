class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:id])
    if signed_in?
      current_user.follow!(@user)
      if params[:mini]
        @user_id = params[:id]
        render :template => 'relationships/create_mini'
      else
        respond_to do |format|
          format.html { redirect_to @user }
          format.js
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    if signed_in?
      current_user.unfollow!(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

end
