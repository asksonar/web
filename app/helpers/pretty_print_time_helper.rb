module PrettyPrintTimeHelper
  # pretty print seconds
  def ppt_seconds(seconds)
    if seconds > 60 * 60
      Time.at(seconds).strftime('%-Hh %-Mm %-Ss')
    elsif seconds > 60
      Time.at(seconds).strftime('%-Mm %-Ss')
    else
      Time.at(seconds).strftime('%-Ss')
    end
  end


  def ppt_date(date)
    date.strftime("%B %d, %Y")
  end

  def ppt_date_abbr(date)
    date.strftime("%b %d")
  end
end
