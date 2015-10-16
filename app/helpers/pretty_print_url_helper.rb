module PrettyPrintUrlHelper
  def ppu_http(url)
    if url.start_with?('http://', 'https://', 'mailto:')
      url
    else
      'http://' + url
    end
  end
end
