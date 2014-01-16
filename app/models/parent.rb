class Parent < User
  REMINDER_DELIVERY_PREFERENCES =
    Map.new \
      :email_only    => 1,
      :sms_only      => 2,
      :email_and_sms => 3

  Fattr( :default_user_mailer_klass ){ UserMailer }
  fattr( :user_mailer_klass ){ self.class.default_user_mailer_klass }

  Fattr( :default_user_sms_notifier_klass ){ UserSmsNotifier }
  fattr( :user_sms_notifier_klass ){ self.class.default_user_sms_notifier_klass }

  has_many :recipients, :foreign_key => "user_id"
  has_many :deliveries, :through => :recipients, :source => :delivery
  has_many :children, :foreign_key => "user_id"
  has_many :kids, :through => :children, :source => :kid
  accepts_nested_attributes_for :kids, allow_destroy: true, reject_if: lambda {|attributes| attributes['name'].blank?}
  accepts_nested_attributes_for :deliveries, allow_destroy: true, reject_if: lambda {|attributes| attributes['email'].blank?}

  def deliver(kid, image_url, caption)
    self.deliveries.each do |delivery|
      puts "sending email to #{delivery.email} id=#{delivery.id}"
      ret = user_mailer_klass.daily_mail(delivery, self, kid, image_url, caption).deliver
      puts ret.inspect
    end
  end

  def send_upload_email_reminder
    user_mailer_klass.upload_reminder( self ).deliver
  end

  def send_upload_reminder
    case reminder_delivery_preference
    when REMINDER_DELIVERY_PREFERENCES.email_only
      send_upload_email_reminder
    when REMINDER_DELIVERY_PREFERENCES.sms_only
      send_upload_sms_reminder
    when REMINDER_DELIVERY_PREFERENCES.email_and_sms
      send_upload_email_reminder
      send_upload_sms_reminder
    else
      # do nothing
    end
  end

  def send_upload_sms_reminder
    user_sms_notifier_klass.new.upload_reminder self
  end

  def upload(filename, content, caption)
    smug_mug = SmugMug.new
    self.kids.each do |kid|
      ret = smug_mug.put_resource(kid.album.smugmug_id, filename, content, caption) if kid.album.smugmug_id
      email_hash = {
        :parent_id => self.id,
        :kid_id => kid.id,
        :image_id => ret['Image']['id'],
        :image_key => ret['Image']['Key'],
        :caption => caption
      }
      ScheduledEmail.create email_hash
    end
  end
end
