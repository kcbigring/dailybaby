require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'no attachments in daily email' do
    mailer = daily_email
    assert_empty mailer.attachments
  end

  test 'places image in daily html email' do
    mailer = daily_email

    assert_match \
      /#{ medium_url }/i,
      mailer.html_part.body.to_s
  end

  test 'upload reminder uses default language if no kids' do
    p =
      Parent.new \
        :email => Faker::Internet.email

    mailer = upload_reminder_email p

    assert_match \
      /your child/i,
      mailer.text_part.body.to_s
  end

  test 'upload reminder uses child name in subject if present' do
    mailer = upload_reminder_email

    assert_match \
      /#{ default_parent.kids.first.name }/i,
      mailer.text_part.body.to_s
  end

  test 'upload reminder reply to is gallery.thedailybaby.com address' do
    mailer = upload_reminder_email

    matches =
      mailer.reply_to.select do | address |
        address.to_s =~ /gallery\.thedailybaby\.com/i
      end

    assert_not_empty matches
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

    # March 1st birthday
    kid =
      Kid.new \
        :album     => album,
        :birthdate => DateTime.parse( '01/03/2013' ).to_date,
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

  def default_parent
    return @_default_parent if @_default_parent.present?

    p =
      Parent.new \
        :email => Faker::Internet.email

    k =
      Kid.new \
        :name => Faker::Name.first_name

    p.kids << k

    @_default_parent = p
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

  def upload_reminder_email( parent = default_parent )
    klass.upload_reminder parent
  end
end
