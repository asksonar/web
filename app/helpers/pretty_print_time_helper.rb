module PrettyPrintTimeHelper
  # pretty print seconds
  def ppt_seconds(seconds)
    if seconds > 60 * 60
      Time.at(seconds).strftime('%-H:%M:%S')
    else
      Time.at(seconds).strftime('%M:%S')
    end
  end

  def ppt_duration(seconds)
    if seconds > 60 * 60
      Time.at(seconds).strftime('%-Hh %-Mm %-Ss')
    elsif seconds > 60
      Time.at(seconds).strftime('%-Mm %-Ss')
    else
      Time.at(seconds).strftime('%-Ss')
    end
  end

  def ppt_date(date)
    local_time(date, '%B %d, %Y')
  end

  def ppt_date_abbr(date)
    local_time(date, '%b %d')
  end
end
