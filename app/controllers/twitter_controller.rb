class TwitterController < ApplicationController
  def index

      new_id = []
      new_name = []
      auth = request.env["omniauth.auth"]
      #render :text => auth.to_yaml
      if not auth.blank?
        @p= Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
        if not @p.blank?
          @p.oauth_token = auth['credentials']['token']
          @p.oauth_secret = auth['credentials']['secret']
          @p.save!
      end

      else
        @p= Authentication.find_by_user_name_and_provider(current_user.email,'twitter')
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
        puts 'Either Database Record present or Internet is not working and no database record'

      end

      @twitter = Twitter::REST::Client.new do |data|
          data.consumer_key        = '4aoAvVdwkNNSA9QsjiWw'
          data.consumer_secret     = 'epZ6d87qsFskmstjpueeWBxyKZLG1UFF20vefmAplQ'
          data.access_token        = @p.oauth_token
          data.access_token_secret = @p.oauth_secret
      end
      if @twitter.nil?
            puts "Twitter connection has failed. Check access_token and access_token_secret. They Might have expired."
      else
          @prev_data= Follower.find_by_uid_and_provider(@p.uid,@p.provider)
          if @prev_data.blank?
                @twitter.followers.each do |f|
                    new_id << f.id
                    new_name << f.name
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
#              @prev_data = @f
              prev_id = @prev_data.follower_id.split(',') #Array of previos ids from Database
              prev_name = @prev_data.follower_name.split(',') #Array of previos Name from Database
              @prev_hash = Hash[prev_id.zip prev_name]
              @twitter.followers.each do |n|
                  new_id << n.id.to_s #Array of new ids from Database
              end
              new_name = @twitter.followers.collect{|s| s.name} #Array of new Name from Database
              @new_hash = Hash[new_id.zip new_name]
              puts "Previous Id is :"
              puts prev_id
              puts prev_id.inspect
              puts "New Id is"
              puts new_id
              puts new_id.inspect
#              @diff_id = prev_id - new_id
              @unfollowers = prev_id - new_id
                puts "Difference id is :"
                puts @diff_id
#              @diff_name = prev_name - new_name
#               puts "Difference name is :"
#              puts @diff_name
              @new_followers = new_id - prev_id
              @email_id = @p.email
              #UserMailer.welcome_email(@prev_hash, @unfollowers,@email_id,@new_hash,@new_followers).deliver
              @prev_data.follower_id = new_id.join(',')
              @prev_data.follower_name = new_name.join(',')
              @prev_data.save!
          end
      #    Follower.all.each do |y|
      #       y.follow = false
      #        y.save!
      #    end
      #    @twitter.followers.each do |f|
      #        if x=Follower.find_by_ids(f.id)
      #            x.follow = true
      #            x.save!
      #        else
      #            db=Follower.new
      #            db.name= f.name
      #            db.ids= f.id
      #            db.follow = true
      #            db.save!
      #        end
      #    end           
      #    @f= Follower.all
      #    @nf = Follower.find(:all , :conditions => {:follow => false})
      #    UserMailer.welcome_email(@nf).deliver
      #    @nf.each do |del|
      #        del.delete
      #        del.save!
      #    end
      end          
  end


  def welcome
  end

  def registered
    @p = Authentication.find_by_uid(params[:uid],'twitter')
    @p.email = params[:user_email_id]
    @p.save!
  end
end
