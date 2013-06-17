OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'c6mnXQYkbB2ARMx2JIxAaw', 'dVPLjg3a50YeuIVjGgHudIYXcH1L8hg05RCnAZOFxI'
  provider :facebook, '378016135633790', '21c5e4f60737fb99b2701541c5b26377', scope: "user_birthday", :client_options => {:ssl => {:verify => false}}
end