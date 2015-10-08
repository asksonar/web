class ScenarioResultsService
  include Singleton

  def create_result_and_panelist(scenario, email)
    panelist = Panelist.find_by(email: email)
    if panelist.nil?
      panelist = Panelist.create(email: email)
    end

    ScenarioResult.create(scenario: scenario, panelist: panelist)
  end

  def update_result_status(scenario_result, status)
    scenario_result.status = status
    scenario_result.save
  end
end
