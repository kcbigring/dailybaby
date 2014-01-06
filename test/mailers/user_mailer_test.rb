require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'successfully delivers daily mail' do
    user    = User.new :email => Faker::Internet.email
    parent  = Parent.new
    caption = 'Yay!'
    album   = Album.new :custom_url => 'https://google.com'

    kid =
      Kid.new \
        :album     => album,
        :birthdate => DateTime.parse( '03/01/2013' ).to_date,
        :name      => 'Sean'

    image_url =
      {
        :medium   => 'http://pictures.thedailybaby.com/Porter/i-BCHvVM3/0/M/pats-M.jpg',
        :original => 'http://pictures.thedailybaby.com/Porter/i-BCHvVM3/0/O/pats.jpg'
      }

    mailer =
      klass.daily_mail \
        user,
        parent,
        kid,
        image_url,
        caption

    before_count = ActionMailer::Base.deliveries.size
    mailer.deliver
    delivery = ActionMailer::Base.deliveries.last
    after_count = ActionMailer::Base.deliveries.size

    assert_operator \
      after_count,
      :>,
      before_count

    refute_empty delivery.attachments
  end

  private

  def klass
    UserMailer
  end
end
