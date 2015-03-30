class ScenarioStepVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :scenario_step

  def share_link
    'http://localhost:3000/share/videos/' + id.to_s
  end
end
