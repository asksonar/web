class ResponsesService
  include Singleton

  def handle_touch(company_uuid:, email:, date_yyyymmdd:, ip_address:)
    company = Company.find_by_uuid(company_uuid)
    survey_settings = company.survey_settings

    responder = upsert_responder(company, email, ip_address)
    upsert_touch(responder, date_yyyymmdd)
    create_response_if_needed(responder, ip_address, survey_settings)
  end

  # status can overwrite dismissed status
  # rating cannot overwrite existing rating
  # text cannot overwrite existing text
  def update_response(uuid, rating: nil, text: nil)
    response = Response.find_by_uuid(uuid)
    if response.rating.nil?
      response.rating = rating
      response.nps = calculate_nps(rating)
      response.date_yyyymmdd = DateTime.now.strftime('%Y%m%d').to_i
    end
    response.status = 'answered'     if !response.rating.nil?
    response.text = text.try(:strip) if response.text.nil?
    response.text = nil              if response.text.blank?
    response.save
  end

  # status can only be set to dismissed if it was unanswered
  # you can't override the status once it's been answered
  def dismiss_response(uuid)
    response = Response.find_by_uuid(uuid)
    response.dismissed! if response.unanswered?
  end

  def unsubscribe_response(uuid)
    dismiss_response(uuid)
    response = Response.find_by_uuid(uuid)
    response.responder.update(unsubscribed_at: DateTime.now)
  end

  private

  def calculate_nps(rating)
    case rating.to_i
    when 9..10
      1
    when 7..8
      0
    when 0..6
      -1
    end
  end

  def create_response_if_needed(responder, ip_address, survey_settings)
    return {} if survey_settings.survey_type != 'inapp'

    response_params = {}

    style_elements = survey_settings.style_elements.nil? ? {} : JSON.parse(survey_settings.style_elements)
    response_params.merge!(style_elements: style_elements)

    latest_response = find_latest_response(responder)
    if latest_response.nil?
      new_response = create_new_empty_response(responder, ip_address)
      response_params.merge!(uuid: new_response.uuid)
    elsif latest_response.created_at.before?(survey_settings.survey_frequency.days.ago)
      new_response = create_new_empty_response(responder, ip_address)
      response_params.merge!(uuid: new_response.uuid)
    elsif latest_response.unanswered?
      response_params.merge!(uuid: latest_response.uuid)
    end

    response_params
  end

  # ip_address is set only on the creation of the row, not subsequent calls
  # we know that ip_address is correct for subsequent calls because we get passed the uuid
  def create_new_empty_response(responder, ip_address)
    # responder.responses.create failed sometimes with ActiveRecord::RecordNotUnique (PG::UniqueViolation: ERROR:  duplicate key value violates unique constraint "responses_pkey"
    # TODO: maybe this magically makes a difference? maybe something strange in scoping?
    Response.create(
      responder: responder,
      uuid: SecureRandom.uuid,
      ip_address: ip_address,
      survey_type: 'inapp'
    )
  end

  def find_latest_response(responder)
    responder.responses.order(created_at: :desc).first
  end

  def upsert_touch(responder, date_yyyymmdd)
    responder.touches.find_or_create_by(date_yyyymmdd: date_yyyymmdd.to_i)
    responder.update(last_touch: Time.now)
  end

  def upsert_responder(company, email, ip_address)
    responder = company.responders.find_or_create_by(email: email)
    update_ip_address(responder, ip_address)
    responder
  end

  def update_ip_address(responder, ip_address)
    ip_addresses = (responder.ip_addresses || '').split(',')
    most_recent_ip_address = ip_addresses[-1]
    responder.ip_addresses = ip_addresses.push(ip_address).uniq.join(',')
    responder.save

    calculate_geoip(responder, ip_address) if most_recent_ip_address != ip_address
  end

  def calculate_geoip
    responder.region, responder.country = GeoIpUtility.instance.lookup_ip_address(ip_address)
    responder.save
  end
end
