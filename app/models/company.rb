class Company < ActiveRecord::Base
  has_many :researchers, inverse_of: :company
end
