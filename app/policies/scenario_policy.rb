class ScenarioPolicy < ApplicationPolicy
  attr_reader :researcher, :scenario

  def initialize(researcher, scenario)
    @researcher = researcher
    @scenario = scenario
  end

  def show?
    researcher.super_admin? or researcher == scenario.created_by
  end

  def edit?
    researcher.super_admin? or researcher == scenario.created_by
  end

  def update?
    researcher.super_admin? or researcher == scenario.created_by
  end

  def destroy?
    researcher.super_admin? or researcher == scenario.created_by
  end
end
