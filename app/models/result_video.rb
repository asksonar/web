class ResultVideo < ActiveRecord::Base
  belongs_to :scenario_result
  enum status: [:pending, :uploaded]

  HASHIDS_SALT = 'Akn94V3&%9Tu'
end
