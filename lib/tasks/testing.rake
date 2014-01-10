namespace :testing do
  task :daily_email => :environment do
    ActiveRecord::Base.transaction do
      [
        Parent,
        Kid,
        ScheduledEmail,
        Delivery,
        Recipient,
        Child
      ].map &:destroy_all

      s = SmugMugWrapper.new

      a =
        s.client.albums.detect do | album |
          album.title =~ /oreo/i
        end

      i = a.images.last

      p =
        Parent.create \
          :email => DEVELOPMENT_EMAIL,
          :name  => Faker::Name.first_name

      d =
        Delivery.create \
          :email => DEVELOPMENT_EMAIL,
          :name  => Faker::Name.first_name

      r =
        Recipient.create \
          :user     => p,
          :delivery => d

      k =
        Kid.create \
          :name => Faker::Name.first_name,
          :birthdate => Date.parse( '14/02/2013' )

      ka =
        Album.create \
          :custom_url => 'http://thedailybaby.com',
          :kid        => k,
          :password   => 'password'

      c =
        Child.create \
          :user => p,
          :kid  => k

      e =
        ScheduledEmail.create \
          :parent    => p,
          :kid       => k,
          :delivered => false,
          :caption   => 'Testing',
          :image_id  => i.id,
          :image_key => i.key

      RecipientEmails.deliver

      raise ActiveRecord::Rollback
    end
  end
end
