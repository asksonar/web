class ScenarioStepFeeling < ActiveRecord::Base
  enum feeling: [:delighted, :confused]
end
