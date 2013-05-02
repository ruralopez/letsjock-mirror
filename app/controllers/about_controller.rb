class AboutController < ApplicationController
  def index
  end
  
  def contact
    if params[:name]
      UserMailer.contact_us( { :name => params[:name], :email => params[:email], :message => params[:message] } ).deliver
    end
    
    redirect_to about_path
  end
end
