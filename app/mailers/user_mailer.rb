class UserMailer < ActionMailer::Base
  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Registered", :from => "letsjock@gmail.com")
  end
end