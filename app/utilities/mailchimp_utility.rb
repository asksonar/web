class MailchimpUtility
  include Singleton

  API_KEY = Rails.configuration.properties['mailchimp_api_key']
  LIST_IDS = Rails.configuration.properties['mailchimp_list_ids']

  def initialize
    @mailchimp = Mailchimp::API.new(API_KEY)
  end

  def subscribe_alpha_users(email)
    begin
      #http://www.rubydoc.info/gems/mailchimp-api/2.0.4/Mailchimp/Lists#subscribe-instance_method
      @mailchimp.lists.subscribe(
        LIST_IDS['alpha_users'], #id
        { email: email }, #email
        nil, #merge_vars
        'html', #email_type
        false) #double_optin
    rescue Mailchimp::ListAlreadySubscribedError
      Rails.logger.info "#{email} was already subscribed to the alpha users list"
    end
  end

end
