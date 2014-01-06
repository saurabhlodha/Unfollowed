class FacebookController < ApplicationController
  def index
  	new_id = []
    new_name = []
  	auth = request.env["omniauth.auth"]
    #render :text => auth.to_yaml
     
    if not auth.blank?
        @p= Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
        if not @p.blank?
        	@p.oauth_token = auth['credentials']['token']
        	@p.save!
    	end
    else
        @p= Authentication.find_by_user_name_and_provider(current_user.email,'facebook')
        puts 'omniauth NOT BEING USED. Authentication is already completed. access_token & access_token_secret fetched from database'      
    end


    if  @p.blank?
        @p=Authentication.new
        @p.provider = auth['provider']
        @p.uid = auth['uid']
#          @p.user_name = auth['info']['name'] #Username is saved as Your Twitter Account name.
        @p.user_name = current_user.email
        @p.email = current_user.email
        @p.oauth_token = auth['credentials']['token']
        @p.oauth_secret = auth['credentials']['secret']
        if @p.save!
                      
        else
          Rails.logger.info "insde error+++#{s.inspect}"
        end

    else
        puts 'Internet is not working and no database record'

    end
    @facebook = Koala::Facebook::API.new(@p.oauth_token)
    friends = @facebook.get_connections("me", "friends")
    @oauth = Koala::Facebook::OAuth.new('436165429817452', '5fda8ab241c136f75b79fe99fd62e4b2')
    puts @oauth.get_user_info_from_cookies(cookies)
    
    if friends.blank?
    	puts "Facebook connection has failed. Check access_token. It Might have expired."
    else
		    @prev_fb_data= Follower.find_by_uid_and_provider(@p.uid,@p.provider)
		          if @prev_fb_data.blank?
		                friends.each do |f|
		                    new_id << f['id']
		                    new_name << f['name']
		                end
		                ids = new_id.join(',')
		                name = new_name.join(',')
		                db = Follower.new
		                db.provider = @p.provider
		                db.uid = @p.uid
		                db.follower_name = name
		                db.follower_id = ids 
		                db.save!               
		                redirect_to :controller => 'welcome', :action => 'edit'
		          else
		#              @prev_fb_data = @f
		              prev_id = @prev_fb_data.follower_id.split(',') #Array of previos ids from Database
		              prev_name = @prev_fb_data.follower_name.split(',') #Array of previos Name from Database
		              @prev_hash = Hash[prev_id.zip prev_name]

		              friends.each do |n|
		                  new_id << n['id'] #Array of new ids from Facebook
		                  new_name << n['name'] #Array of new Name from Facebook
		              end
		              
		              @new_hash = Hash[new_id.zip new_name]
		              #puts "Previous Id is :"
		              #puts prev_id
		              #puts prev_id.inspect
		              #puts "New Id is"
		              #puts new_id
		              #puts new_id.inspect
		#              @diff_id = prev_id - new_id
		              @unfriended = prev_id - new_id
		                #puts "Difference id is :"
		                #puts @diff_id
		#              @diff_name = prev_name - new_name
		#               puts "Difference name is :"
		#              puts @diff_name
		              @new_friends = new_id - prev_id
		              @email_id = @p.email
		              UserMailer.welcome_email(@prev_hash, @unfriended,@email_id,@new_hash,@new_friends).deliver
		              @prev_fb_data.follower_id = new_id.join(',')
		              @prev_fb_data.follower_name = new_name.join(',')
		              @prev_fb_data.save!
		          end
	end
  end

  def welcome
  end

  def registered
    @p = Authentication.find_by_uid_and_provider(params[:uid],'facebook')
    @p.email = params[:user_email_id]
    @p.save!
  end



end
