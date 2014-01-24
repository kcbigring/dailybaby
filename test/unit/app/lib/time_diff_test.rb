require 'test_helper'

class TimeDiffTest < ActiveSupport::TestCase
  test 'can compute time diffs' do
    assert_respond_to \
      TimeDiff,
      :compute
  end

  [
    [
      '06/01/2014', # January 6th
      '06/12/2013', # December 6th
      {
        :year  => 0,
        :month => 1,
        :week  => 0,
        :day   => 0
      }
    ],
    [
      '23/01/2014', # January 22nd
      '16/01/2014', # January 16th
      {
        :year  => 0,
        :month => 0,
        :week  => 1,
        :day   => 0
      }
    ],
    [
      '06/01/2014', # January 6th
      '31/01/2012', # January 31st
      {
        :year  => 1,
        :month => 11,
        :week  => 0,
        :day   => 6
      }
    ],
    [
      '06/01/2014', # January 6th
      '22/02/2013', # February 22nd
      {
        :year  => 0,
        :month => 10,
        :week  => 2,
        :day   => 1
      }
    ],
    [
      '24/02/2014', # February 24th
      '24/02/2013', # February 24th
      {
        :year  => 1,
        :month => 0,
        :week  => 0,
        :day   => 0
      }
    ],
    [
      '06/01/2014', # January 6th
      '24/02/2013', # February 24th
      {
        :year  => 0,
        :month => 10,
        :week  => 1,
        :day   => 6
      }
    ],
    [
      '07/01/2014', # January 7th
      '11/05/2013', # May 11th
      {
        :year  => 0,
        :month => 7,
        :week  => 3,
        :day   => 6
      }
    ]
  ].each do | example |
    test "diff end:#{ example[ 0 ] } start:#{ example[ 1 ] }" do
      check_date = Date.parse example[ 0 ]
      birth_date = Date.parse example[ 1 ]
      expected   = example[ 2 ]

      computed =
        TimeDiff.compute \
          check_date,
          birth_date

      computed.delete_if do | key , _ |
        !expected.keys.include?( key )
      end

      assert_equal \
        expected,
        computed
    end
  end
end
