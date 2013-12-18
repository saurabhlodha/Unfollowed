class WelcomeController < ApplicationController
  before_filter :authenticate_user!
  def index
  	@pt= Authentication.find_by_user_name_and_provider(current_user.email,'twitter')
    @pf= Authentication.find_by_user_name_and_provider(current_user.email,'facebook')
  	if not @pt.blank?
        puts 'omniauth NOT BEING USED. Authentication is already completed. access_token & access_token_secret fetched from database'
      
        @urlt = twitter_index_path
  	else
  		@urlt = "/auth/twitter"
  	end

    if not @pf.blank?
        puts 'omniauth NOT BEING USED. Authentication is already completed. access_token & access_token_secret fetched from database'
      
       # @urlf = facebook_index_path
       @urlf = "/auth/facebook"
    else
      @urlf = "/auth/facebook"
    end

  end

  def new

  end
end
