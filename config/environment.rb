# Load the Rails application.
require File.expand_path('../application', __FILE__)
ActionMailer::Base.smtp_settings = {
  :user_name => 'app20576491@heroku.com',
  :password => 'dqiouumo',
  :domain => 'http://know-who-unfollowed.herokuapp.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
# Initialize the Rails application.
Unfollowed::Application.initialize!
