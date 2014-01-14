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
      @medium_url = image_url
    else
      @medium_url = ''
    end

    mail \
      :subject => subject_for( kid ),
      :to      => user.email.to_s
  end

  def upload_reminder( parent )
    @parent_name = parent.name

    kid_name  =   parent.kids.map( &:name ).detect &:present?
    kid_name  ||= 'your child'
    @kid_name =   kid_name

    mail \
      :subject  => "Hello. This is your Daily Baby Reminder.",
      :reply_to => 'The Daily Baby <upload@gallery.thedailybaby.com>',
      :to       => parent.email.to_s
  end

  private

  def get_image_name(image_url)
    splits = image_url.split('/')
    splits[splits.length - 1]
  end

  def subject_for( kid )
    subject = kid.name
    time_diff = TimeDiff.compute(DateTime.now, kid.birthdate)

    DailyMailSubject.compile \
      kid.name,
      time_diff
  end
end
