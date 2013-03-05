ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com",
:port => "587",
:domain => "letsjock.com",
:user_name => "letsjock",
:password => "1Proy2.cl",
:authentication => "plain",
:enable_starttls_auto => true
}
ActionMailer::Base.default_url_options[:host] = "letsjock.herokuapp.com"