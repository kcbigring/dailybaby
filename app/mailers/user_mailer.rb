require 'net/http'

class UserMailer < ActionMailer::Base
  default from: "rob@thedailybaby.com"
  
  def daily_mail(user, parent, kid, image_url, caption)
    @user = user
    @parent = parent
    @kid = kid
    @caption = caption
    attachments[get_image_name(image_url)] = Net::HTTP.get_response(image_url).body
    time_diff = Time.diff(DateTime.now, kid.birthdate)

    subject = kid.name
    subject += " at "
    subject += ("#{time_diff[:year]} year ") if time_diff[:year] == 1
    subject += ("#{time_diff[:year]} years ") if time_diff[:year] > 1
    
    subject += ("#{time_diff[:month]} month ") if time_diff[:month] == 1
    subject += ("#{time_diff[:month]} months ") if time_diff[:month] > 1
    
    subject += ("#{time_diff[:day]} day") if time_diff[:day] == 1
    subject += ("#{time_diff[:day]} days") if time_diff[:day] > 1
    
    mail(:to => "#{user.email}", :subject => subject)
  end
  
  private
  
  def get_image_name(image_url)
    splits = image_url.split('/')
    splits[splits.length - 1]
  end
end