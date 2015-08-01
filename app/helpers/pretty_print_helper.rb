module PrettyPrintHelper
  # pretty print seconds
  def pp_plural(number, text)
    if number == 1
      text
    else
      text + 's'
    end
  end

  def pp_plural_with_number(number, text)
    if number == 1
      number.to_s + ' ' + text
    else
      number.to_s + ' ' + text + 's'
    end
  end

end
