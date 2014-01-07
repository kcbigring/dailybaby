require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'successfully delivers daily mail' do
    mailer = daily_email

    before_count = ActionMailer::Base.deliveries.size
    mailer.deliver
    after_count = ActionMailer::Base.deliveries.size

    assert_operator \
      after_count,
      :>,
      before_count
  end

  test 'attaches image to email' do
    mailer = daily_email
    refute_empty mailer.attachments
  end

  test 'places image in html email' do
    mailer = daily_email

    assert_match \
      /#{ medium_url }/i,
      mailer.html_part.body.to_s
  end

  private

  def daily_email
    user    = User.new :email => Faker::Internet.email
    parent  = Parent.new
    caption = 'Yay!'

    album =
      Album.new \
        :custom_url => 'https://google.com',
        :password   => 'password'

    kid =
      Kid.new \
        :album     => album,
        :birthdate => DateTime.parse( '03/01/2013' ).to_date,
        :name      => 'Sean'

    image_url =
      {
        :medium   => medium_url,
        :original => 'http://pictures.thedailybaby.com/Porter/i-BCHvVM3/0/O/pats.jpg'
      }

    email =
      klass.daily_mail \
        user,
        parent,
        kid,
        image_url,
        caption,
        mock_kernel_klass

    email
  end

  def klass
    UserMailer
  end

  def medium_url
    @_medium_url ||= 'http://pictures.thedailybaby.com/Porter/i-BCHvVM3/0/M/pats-M.jpg'
  end

  def mock_kernel_klass
    @_mock_kernel_klass ||=
      Class.new do
        def self.open( *args , &block )
          # fake_file_path = "#{ Rails.root }/test/support/images/pats-M.jpg"
          # Kernel.open fake_file_path do | io |
          #   yield io if block_given
          # end
        end
      end
  end
end
