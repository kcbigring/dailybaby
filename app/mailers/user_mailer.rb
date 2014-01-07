require 'uri'
require 'open-uri'

class UserMailer < ActionMailer::Base
  default from: "The Daily Baby <pictures@thedailybaby.com>"

  def daily_mail(user, parent, kid, image_url, caption)
    @user = user
    @parent = parent
    @kid = kid
    @caption = caption

    if image_url.present?
      @medium_url  = image_url[ :medium ]
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
