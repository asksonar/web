class ResponsesPresenter
  attr_reader :uuid

  def initialize(uuid)
    @uuid = uuid
  end

  def response
    @response ||= Response.find_by_uuid(uuid)
  end

  def responder
    @responder ||= response.responder
  end

  def company
    @company ||= responder.company
  end

  def company_name
    company.name
  end
end
