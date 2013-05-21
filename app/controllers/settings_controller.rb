class SettingsController < ApplicationController

  def index
    if signed_in?
      @user = current_user
      @settings = true
    end
  end

  def new_password_form
    if signed_in?
      @user = current_user
      if params[:password] == params[:password_confirmation]
        if @user.compare_password(params[:current_password])
          if @user.update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation])
            flash[:success] = "Your password has been changed."
            redirect_to settings_path
          end
        else
          flash[:error] = "Incorrect password."
          redirect_to settings_path
        end
      else
        flash[:error] = "Passwords did not match."
        redirect_to settings_path
      end
    end
  end

end
