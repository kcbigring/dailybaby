class DailyMailSubject
  attr_reader \
    :kid_name,
    :time_diff

  def self.compile( *args , &block )
    new( *args , &block ).compiled
  end

  def initialize( kid_name , time_diff )
    @kid_name ||= kid_name
    @time_diff ||= time_diff
  end

  #
  # `time_kind` must be singular form of year, month, week, or day
  #
  def build_count_for( time_kind )
    num = number_of time_kind
    return '' if num < 1
    "#{ num } #{ time_kind.to_s.downcase.pluralize( num ) }"
  end

  def build_days
    build_count_for :day
  end

  def build_months
    build_count_for :month
  end

  def build_subject
    "#{ kid_name } at #{ build_time_diff }"
  end

  def build_time_diff
    [
      build_years,
      build_months,
      build_weeks,
      build_days
    ].select( &:present? ).join ' '
  end

  def build_weeks
    build_count_for :week
  end

  def build_years
    build_count_for :year
  end

  def compiled
    @_compiled ||= build_subject
  end

  def num_days
    @_num_days ||= Integer time_diff[:day]
  rescue
    0
  end

  def num_months
    @_num_months ||= Integer time_diff[:month]
  rescue
    0
  end

  def num_weeks
    @_num_weeks ||= Integer time_diff[:week]
  rescue
    0
  end

  def num_years
    @_num_years ||= Integer time_diff[:year]
  rescue
    0
  end

  def number_of( time_kind )
    case time_kind.to_s
    when /year/i
      num_years
    when /month/i
      num_months
    when /week/i
      num_weeks
    when /day/i
      num_days
    else
      raise ArgumentError.new( 'Unknown time kind!' )
    end
  end
end
