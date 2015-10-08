class Panelist < ActiveRecord::Base
  has_many :scenario_results

  HASHIDS_SALT = '3tufg2pFpRR@'
end
