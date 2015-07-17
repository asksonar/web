module PrettyPrintTimeHelper
  # pretty print seconds
  def ppt_seconds(seconds)
    if seconds > 60 * 60
      Time.at(seconds).strftime('%H:%M:%S')
    else
      Time.at(seconds).strftime('%M:%S')
    end
  end

  def ppt_date(date)
    date.strftime("%b %d")
  end
end
