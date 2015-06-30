module PrettyPrintUrlHelper
  def ppu_host(url)
    begin
      if !url.start_with? 'http'
        uri = URI('http://' + url)
      else
        uri = URI(url)
      end

      return uri.host
    rescue
      return url
    end
  end

  def ppu_http(url)
    begin
      if !url.start_with? 'http'
        uri = URI('http://' + url)
      else
        uri = URI(url)
      end

      return uri.to_s
    rescue
      return '<INVALID URL> ' + url
    end
  end
end
