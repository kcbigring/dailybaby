require 'test_helper'

class ParentTest < ActiveSupport::TestCase
  test 'sends only email upload reminder with correct preference' do
    preference = 1
    p = parent_with_mock_delivery_klasses_and_preference preference

    assert_throws :email do
      p.send_upload_reminder
    end
  end

  test 'sends only sms upload reminder with correct preference' do
    preference = 2
    p = parent_with_mock_delivery_klasses_and_preference preference

    assert_throws :sms do
      p.send_upload_reminder
    end
  end

  test 'sends both email and sms upload reminder with correct preference' do
    preference = 3
    p = parent_with_mock_delivery_klasses_and_preference preference

    assert_throws :email do
      p.send_upload_reminder
    end

    p.user_mailer_klass = no_throw_mock_user_mailer_klass

    assert_throws :sms do
      p.send_upload_reminder
    end
  end

  test 'sends no upload reminder with correct preference' do
    preferences =
      [
        0,
        4
      ]

    preferences.each do | preference |
      p = parent_with_mock_delivery_klasses_and_preference preference
      assert_nil p.send_upload_reminder
    end
  end

  private

  def mock_user_mailer_klass
    @_mock_user_mailer_klass ||=
      Class.new do
        def self.upload_reminder( * )
          new
        end

        def deliver
          throw :email
        end
      end
  end

  def mock_user_sms_notifier_klass
    @_mock_user_sms_notifier_klass ||=
      Class.new do
        def upload_reminder( * )
          throw :sms
        end
      end
  end

  def no_throw_mock_user_mailer_klass
    @_no_throw_mock_user_mailer_klass ||=
      Class.new mock_user_mailer_klass do
        def deliver
          true
        end
      end
  end

  def parent_with_mock_delivery_klasses_and_preference( preference )
    p = Parent.new :reminder_delivery_preference => preference
    p.user_mailer_klass = mock_user_mailer_klass
    p.user_sms_notifier_klass = mock_user_sms_notifier_klass
    p
  end
end
