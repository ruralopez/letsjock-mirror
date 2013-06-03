class SessionsController < ApplicationController

  def new
  end

  def create
    if params[:provider] == "facebook"
      omniauth = request.env['omniauth.auth']
      if omniauth
        if User.exists?(:email => omniauth['extra']['raw_info']['email'])
          userFB = User.find_by_email(omniauth['extra']['raw_info']['email'])
          sign_in userFB
          redirect_to news_path
        else

        end
      else
        flash[:error] = "Something went wrong."
        redirect_to root_url
      end
    elsif params[:provider] == "twitter"
      omniauth = request.env['omniauth.auth']
      if omniauth
        render :text => omniauth
      end
    else
      if params[:session]
        user = User.find_by_email(params[:session][:email].downcase)
        @pass = params[:session][:password]
      else
        user = User.find_by_email(params[:email].downcase)
        @pass = params[:password]
      end
      if user && user.authenticate(@pass)
        if user.authentic_email
          sign_in user
          redirect_to news_path
        else
          flash[:notice] = "You have not verified your email adress.\n "
          redirect_to root_url(:email_attempt => user.email)
        end
      else
        flash[:error] = 'The email or password you entered is incorrect.'
        redirect_to root_url
      end
    end
  end

  def destroy
    sign_out
    flash[:success] = "You have successfully logged out."
    redirect_to root_url
  end

end
