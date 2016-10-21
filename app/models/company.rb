class Company < ActiveRecord::Base
  has_many :users, inverse_of: :company
  has_many :datatable_views, inverse_of: :company
  has_many :analysis_views, inverse_of: :company

  after_initialize :default_values, unless: :persisted?
  after_create :create_datatable_view
  after_create :create_analysis_view

  HASHIDS_SALT = '&8cCkHr#gHYk'

  def default_values
    self.uuid = SecureRandom.uuid if uuid.nil?
  end

  def create_datatable_view
    DatatableView.create(company_id: self.id)
  end

  def create_analysis_view
    AnalysisView.create(company_id: self.id)
  end
end
