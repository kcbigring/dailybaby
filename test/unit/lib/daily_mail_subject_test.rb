require 'test_helper'

class DailyMailSubjectTest < ActiveSupport::TestCase
  test 'only includes time parts if needed' do
    time_parts.each do | time_part |
      num = 1

      subject =
        klass.compile \
          kid_name,
          { time_part => num }

      assert_equal \
        "#{ kid_name } at #{ num } #{ time_part }",
        subject
    end
  end

  test 'pluralizes if the part has more than one' do
    num = 2
    time_part = :day

    subject =
      klass.compile \
        kid_name,
        { time_part => num }

    assert_equal \
      "#{ kid_name } at #{ num } #{ time_part }s",
      subject
  end

  test 'memoizes the subject once compiled' do
    num = 2
    time_part = time_parts.last

    subject =
      klass.new \
        kid_name,
        { time_part => num }

    assert_equal \
      subject.compiled.object_id,
      subject.compiled.object_id
  end

  test 'has spaces between time parts' do
    time_diff =
      {
        :week => 1,
        :day  => 1
      }

    subject =
      klass.compile \
        kid_name,
        time_diff

    assert_equal \
      "#{ kid_name } at 1 week 1 day",
      subject
  end

  private

  def kid_name
    @_kid_name ||= 'Ryan'
  end

  def klass
    DailyMailSubject
  end

  def time_parts
    @_time_parts ||=
      [
        :year,
        :month,
        :week,
        :day
      ]
  end
end
