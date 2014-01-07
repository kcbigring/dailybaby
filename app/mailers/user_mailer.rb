require 'uri'
require 'open-uri'

class UserMailer < ActionMailer::Base
  Fattr( :default_kernel_klass ){ Kernel }
  fattr( :kernel_klass ){ self.class.default_kernel_klass }

  default from: "The Daily Baby <pictures@thedailybaby.com>"

  def daily_mail(user, parent, kid, image_url, caption, provided_kernel_klass = Kernel)
    self.kernel_klass = ( provided_kernel_klass or kernel_klass )

    @user = user
    @parent = parent
    @kid = kid
    @caption = caption

    if image_url.present?
      @medium_url  = image_url[ :medium ]
      attach_file_at image_url[ :original ]
    else
      @medium_url = ''
    end

    mail \
      :subject => subject_for( kid ),
      :to      => user.email.to_s
  end

  private

  def attach_file_at( url_or_path )
    attachments[ get_image_name( url_or_path ) ] =
      begin
        # use block form to automatically close IO handles
        kernel_klass.open URI( url_or_path ) do | io |
          io.read
        end
      rescue
        nil
      end
  end

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
