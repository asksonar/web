class UsersPresenter
  def initialize(company_id:, page:)
    @company_id = company_id
    @page = page.to_i
  end

  def page
    @page
  end

  def users
    @users ||= Responder.where(company_id: @company_id).page(@page)
  end
end
