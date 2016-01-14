class ResponsesPresenter
  attr_reader :uuid

  def initialize(uuid)
    @uuid = uuid
  end

  def response
    @response ||= Response.find_by_uuid(uuid)
  end

  def customer
    @customer ||= response.customer
  end

  def company
    @company ||= customer.company
  end

  def company_name
    company.name
  end
end
