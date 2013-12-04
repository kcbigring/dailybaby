class Parent < User
  has_many :recipients, :foreign_key => "user_id"
  has_many :deliveries, :through => :recipients, :source => :delivery
  has_many :children, :foreign_key => "user_id"
  has_many :kids, :through => :children, :source => :kid
  accepts_nested_attributes_for :kids, allow_destroy: true, reject_if: lambda {|attributes| attributes['name'].blank?}
  accepts_nested_attributes_for :deliveries, allow_destroy: true, reject_if: lambda {|attributes| attributes['email'].blank?}

  def deliver(kid, image_url, caption)
    self.deliveries.each do |delivery|
      puts "sending email to #{delivery.email} id=#{delivery.id}"
      ret = UserMailer.daily_mail(delivery, self, kid, image_url, caption).deliver
      puts ret.inspect
    end
  end
  
  def upload(filename, content, caption)
    aws_store = AwsStore.new('dailybaby-email')
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
