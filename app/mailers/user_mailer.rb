require 'uri'
require 'open-uri'

class UserMailer < ActionMailer::Base
  default from: "pictures@thedailybaby.com"

  def daily_mail(user, parent, kid, image_url, caption)
    @user = user
    @parent = parent
    @kid = kid
    @caption = caption
    attachments[get_image_name(image_url)] = open(URI(image_url)).read if image_url rescue nil

    mail \
      :subject => subject_for( kid ),
      :to      => user.email.to_s
  end

  private

  def get_image_name(image_url)
    splits = image_url.split('/')
    splits[splits.length - 1]
  end

  def subject_for( kid )
    subject = kid.name
    time_diff = Time.diff(DateTime.now, kid.birthdate)

    DailyMailSubject.compile \
      kid.name,
      time_diff
  end
end
