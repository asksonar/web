class Researcher < ActiveRecord::Base
  belongs_to :company

  def is_researcher?
    true
  end

end
