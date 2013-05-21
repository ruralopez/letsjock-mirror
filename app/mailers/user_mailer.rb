class UserMailer < ActionMailer::Base
  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Registered", :from => "letsjock@gmail.com")
  end
  
  def contact_us(data)
    @data = data
    mail(:to => "info@letsjock.com", :subject => "Contact form", :from => "letsjock@gmail.com")
  end

  def new_password(user)
    @user = user
    mail(:to => user.email, :subject => "New password request", :from => "letsjock@gmail.com")
  end

  def invitation(data)
    @data = data
    mail(:to => @data[:email], :subject => "Invitation to connect with Let's Jock!", :from => "letsjock@gmail.com")
  end
end