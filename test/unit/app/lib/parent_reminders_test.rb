require 'test_helper'

class ParentRemindersTest < ActiveSupport::TestCase
  def setup
    @p  = Parent.create!
    @p2 = Parent.create!

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

  test 'fetches parents who HAVE NOT ALREADY submitted a photo' do
    parents = @r.parents_without_scheduled_email

    assert_includes \
      parents,
      @p2

    refute_includes \
      parents,
      @p
  end

  private

  def klass
    ParentReminders
  end
end
