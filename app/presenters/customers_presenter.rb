class CustomersPresenter
  attr_reader :page

  def initialize(company_id:, page:)
    @company_id = company_id
    @page = page.to_i
  end

  def users
    @users ||= Responder.where(company_id: @company_id).order(email: :asc).page(@page)
  end
end
