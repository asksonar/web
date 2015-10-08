class Template < ActiveRecord::Base
  enum category: [:product, :marketing]
  has_many :template_steps, -> { order step_order: :asc }, inverse_of: :template

  HASHIDS_SALT = '52X^wGkdt6*T'
end
