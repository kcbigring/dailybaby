require 'test_helper'

class UserSmsNotifierTest < ActiveSupport::TestCase
  test 'returns false if parent is not valid' do
    invalid_parent = Parent.new
    refute instance_with_mock_twilio_klass.upload_reminder( invalid_parent )
  end

  test 'sends message to parent cell phone' do
    p      = Parent.new :cell_phone => '+11234567890'
    i      = instance_with_mock_twilio_klass
    result = i.upload_reminder p

    assert_equal \
      p.cell_phone,
      result.first[ :to ]
  end

  test 'has upload email address in message' do
    p      = Parent.new :cell_phone => '+11234567890'
    i      = instance_with_mock_twilio_klass
    result = i.upload_reminder p

    assert_match \
      /gallery\.thedailybaby\.com/i,
      result.first[ :body ]
  end

  private

  def instance_with_mock_twilio_klass
    i = klass.new
    i.twilio_klass = mock_twilio_klass
    i
  end

  def klass
    UserSmsNotifier
  end

  def mock_twilio_klass
    @_mock_twilio_klass ||=
      Class.new do
        def initialize( *args )
          @initialize_args = args
        end

        def account
          self
        end

        def create( *args )
          args
        end

        def messages
          self
        end
      end
  end
end
