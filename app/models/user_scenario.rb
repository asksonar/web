class UserScenario < ActiveRecord::Base
  enum status: %w(pending inprogress completed)
end
