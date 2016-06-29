class ChangeTableDatatableViews <ActiveRecord:: Migration
  def change
    companies = Company.all

    companies.each do |company|
      DatatableView.create(company_id: company.id)
    end
  end
end
