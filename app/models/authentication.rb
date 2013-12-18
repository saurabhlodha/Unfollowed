class Authentication < ActiveRecord::Base
  attr_accessible :user_id, :provider, :uid, :user_name, :oauth_token, :oauth_secret, :email
end
