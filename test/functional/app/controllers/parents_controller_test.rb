require 'test_helper'

class ParentsControllerTest < ActionController::TestCase
  test 'creates parent' do
    before_count = Parent.count
    email = Faker::Internet.email
    reminder_delivery_preference = rand 5

    post \
      :create,
      :parent =>
        {
          :cell_phone                   => Faker::PhoneNumber.cell_phone,
          :email                        => email,
          :name                         => Faker::Name.name,
          :reminder_delivery_preference => reminder_delivery_preference
        }

    assert_response :found

    after_count = Parent.count

    assert_operator \
      after_count,
      :>,
      before_count

    p = Parent.find_by :email => email
    assert p.present?

    assert_equal \
      reminder_delivery_preference,
      p.reminder_delivery_preference
  end

  test 'updates parent' do
    p =
      Parent.create \
        :cell_phone                   => Faker::PhoneNumber.cell_phone,
        :email                        => Faker::Internet.email,
        :reminder_delivery_preference => rand( 5 )

    new_delivery_preference = rand 5

    put \
      :update,
      {
        :id => p.id,
        :parent => {
          :reminder_delivery_preference => new_delivery_preference
        }
      }

    assert_response :found

    p.reload

    assert_equal \
      new_delivery_preference,
      p.reminder_delivery_preference
  end
end
