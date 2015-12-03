class ResponsesService
  include Singleton

  def handle_touch(company_uuid:, email:, date_yyyymmdd:, ip_address:)
    company = Company.find_by_uuid(company_uuid)
    responder = upsert_responder(company, email, ip_address)
    upsert_touch(responder, date_yyyymmdd)
    create_response_if_needed(responder, ip_address)
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

  private

  def calculate_nps(rating)
    case rating
    when 9..10
      response.nps = 1
    when 7..8
      response.nps = 0
    when 0..6
      response.nps = -1
    end
  end

  def create_response_if_needed(responder, ip_address)
    latest_response = find_latest_response(responder)
    if latest_response.nil?
      create_new_empty_response(responder, ip_address).uuid
    elsif latest_response.unanswered?
      latest_response.uuid
    elsif latest_response.created_at < 30.days.ago
      create_new_empty_response(responder, ip_address).uuid
    end
  end

  # ip_address is set only on the creation of the row, not subsequent calls
  # we know that ip_address is correct for subsequent calls because we get passed the uuid
  def create_new_empty_response(responder, ip_address)
    responder.responses.create(
      uuid: SecureRandom.uuid,
      ip_address: ip_address
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

    if most_recent_ip_address != ip_address
      Resque.enqueue(ProcessGeoIpWorker, responder.id)
    end
  end
end
