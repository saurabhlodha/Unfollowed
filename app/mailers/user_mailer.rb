class UserMailer < ActionMailer::Base
  default from: "from@example.com"

def welcome_email(h, unfollowed, e, nh,newFollowed)
    @hash = h
    @ids = unfollowed
    @email_id = e
    @new_hash =nh
    @new_followers = newFollowed
    @url  = 'http://example.com/login'
    mail(to: @email_id, subject: 'Know who !Followed: Notification')
  end

end
