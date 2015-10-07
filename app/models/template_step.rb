class TemplateStep < ActiveRecord::Base
  belongs_to :template

  HASHIDS_SALT = '2r8mGH^%MVr$'
end
