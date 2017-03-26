module TimeTools
  def validate_time_in_past(time)
    raise 'month is in the future' if month_start(time).future?
  end

  def time_range_month(time)
    begin
      validate_time_in_past(time)
    rescue RuntimeError => e
      logger.debug e.message
      return
    end
    month_start(time)..month_end(time)
  end

  def month_start(time)
    DateTime.new(time.year, time.month, 1).utc
  end

  def month_end(time)
    DateTime.new(time.year, time.month, -1, -1, -1, -1).utc
  end

  # Convert a DateTime to unix time integer
  # @param {DateTime} date_time object
  # @return {Fixnum} unix time
  def unix_time(date_time)
    date_time.to_time.to_i
  end
end
