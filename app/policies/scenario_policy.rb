class ScenarioPolicy < ApplicationPolicy
  attr_reader :researcher, :scenario

  def initialize(researcher, scenario)
    @researcher = researcher
    @scenario = scenario
  end

  def show?
    researcher.super_admin? or researcher == scenario.created_by
  end
end
