class UsersPresenter
  PAGE_SIZE = 20

  def initialize(company_id:, page:)
    @company_id = company_id
    @page = page.to_i
  end

  def page
    @page
  end

  def users
    @users ||= Responder.where(company_id: @company_id).limit(PAGE_SIZE).offset(@page * PAGE_SIZE)
  end
end
