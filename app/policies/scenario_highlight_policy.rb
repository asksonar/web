class ScenarioHighlightPolicy < ApplicationPolicy
  attr_reader :researcher, :scenario_highlight

  def initialize(researcher, scenario_highlight)
    @researcher = researcher
    @scenario_highlight = scenario_highlight
  end

  def edit?
    is_super_admin? or is_owner?
  end

  def update?
    is_super_admin? or is_owner?
  end

  def destroy?
    is_super_admin? or is_owner?
  end

  private

  def is_super_admin?
    researcher.super_admin?
  end

  def is_owner?
    if scenario_highlight.scenario_result.scenario.nil?
      researcher == scenario_highlight.scenario_result.created_by
    else
      researcher == scenario_highlight.scenario_result.scenario.created_by
    end
  end
end
