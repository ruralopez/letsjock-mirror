class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:id])
    if signed_in?
      current_user.follow!(@user)
      if params[:mini]
        @user_id = params[:id]
        render :template => 'relationships/create_mini'
      elsif params[:search]
        render :template => "relationships/search_create"
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
      if params[:search]
        render :template => "relationships/search_destroy"
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

end
