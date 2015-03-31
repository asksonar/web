class ScenarioStepVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :scenario_step

  def share_link
    '/share/videos/' + id.to_s
  end
end
