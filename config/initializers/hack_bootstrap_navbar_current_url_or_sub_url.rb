module BootstrapNavbar::Helpers
  def current_url_or_sub_url?(url)
    uri, current_uri = [url, current_url].map do |url|
      URI.parse(url)
    end
    return false if uri.is_a?(URI::MailTo) || (!uri.host.nil? && uri.host != current_uri.host)
    normalized_path, normalized_current_path = [uri, current_uri].map do |uri|
      uri.path.sub(%r(/\z), '')
    end
    if normalized_path.empty?
      normalized_current_path.empty?
    else
      (normalized_current_path =~ %r(\A#{Regexp.escape(normalized_path)}(/.+)?\z)) and
      (uri.query == current_uri.query)
    end
  end
end
