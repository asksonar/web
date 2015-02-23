module EmailUtils

  #splits by line, comma, semicolon
  def parse_emails(emailsText)
    emails = []

    #split by new line, comma, semicolon
    emailsText.split(/[\r?\n|,;]/).each do |line|
      #grab non-whitespace chunks that contain an @ sign
      emails.push *line.scan(/\S*[@]\S*/).flatten.compact
    end

    # strip out wrapping delimiters
    emails.map! { |email|
      email.scan(%r{
        \A
        \((.+)\)| # parens
        \<(.+)\>| # angle brackets
        \{(.+)\}| # squiggly brackets
        \[(.+)\]| # square brackets
        (.+)
        \z
      }x).flatten.compact[0]
    }
  end

end
