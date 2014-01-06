require 'uri'
require 'open-uri'

class UserMailer < ActionMailer::Base
  default from: "pictures@thedailybaby.com"

  def daily_mail(user, parent, kid, image_url, caption)
    @user = user
    @parent = parent
    @kid = kid
    @caption = caption

    if image_url.present?
      @medium_url = image_url[ :medium ]
      original_url = image_url[ :original ]

      attachments[ get_image_name( original_url ) ] =
        begin
          # use block form to automatically close IO handles
          open URI( original_url ) do | io |
            io.read
          end
        rescue
          nil
        end
    else
      @medium_url = ''
    end

    time_diff = Time.diff(DateTime.now, kid.birthdate)

    subject = kid.name
    subject += " at "
    subject += ("#{time_diff[:year]} year ") if time_diff[:year] == 1
    subject += ("#{time_diff[:year]} years ") if time_diff[:year] > 1
    
    subject += ("#{time_diff[:month]} month ") if time_diff[:month] == 1
    subject += ("#{time_diff[:month]} months ") if time_diff[:month] > 1
    
    subject += ("#{time_diff[:week]} week") if time_diff[:week] == 1
    subject += ("#{time_diff[:week]} weeks") if time_diff[:week] > 1
    
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
