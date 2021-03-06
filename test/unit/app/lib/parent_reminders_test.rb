require 'test_helper'

class ParentRemindersTest < ActiveSupport::TestCase
  def setup
    @p =
      Parent.create! \
        :reminder_delivery_preference => Parent::REMINDER_DELIVERY_PREFERENCES.email_only

    @p2 =
      Parent.create! \
        :reminder_delivery_preference => Parent::REMINDER_DELIVERY_PREFERENCES.sms_only

    ScheduledEmail.create \
      :delivered => false,
      :parent_id => @p.id

    @r = klass.new
  end

  test 'fetches ids of parents who HAVE ALREADY submitted a photo' do
    ids = @r.parent_ids_with_scheduled_email

    assert_includes \
      ids,
      @p.id

    refute_includes \
      ids,
      @p2.id
  end

  test 'fetches parents who prefer reminders' do
    p3 = Parent.create

    parents = @r.parents_who_prefer_reminders

    assert_includes \
      parents,
      @p

    assert_includes \
      parents,
      @p2

    refute_includes \
      parents,
      p3
  end

  test 'fetches parents who HAVE NOT ALREADY submitted a photo' do
    parents = @r.parents_without_scheduled_email

    assert_includes \
      parents,
      @p2

    refute_includes \
      parents,
      @p
  end

  test 'fetches parent to remind even if no parents have already submitted photo' do
    ScheduledEmail.destroy_all
    @p.destroy

    parents = @r.parents_without_scheduled_email

    assert_includes \
      parents,
      @p2
  end

  private

  def klass
    ParentReminders
  end
end
