class ScenarioHighlightPolicy < ApplicationPolicy
  attr_reader :researcher, :scenario_highlight

  def initialize(researcher, scenario_highlight)
    @researcher = researcher
    @scenario_highlight = scenario_highlight
  end

  def edit?
    if researcher.super_admin?
      true
    elsif scenario_highlight.scenario_result.scenario.nil?
      researcher == scenario_highlight.scenario_result.created_by
    else
      researcher == scenario_highlight.scenario_result.scenario.created_by
    end
  end

  def update?
    if researcher.super_admin?
      true
    elsif scenario_highlight.scenario_result.scenario.nil?
      researcher == scenario_highlight.scenario_result.created_by
    else
      researcher == scenario_highlight.scenario_result.scenario.created_by
    end
  end

  def destroy?
    if researcher.super_admin?
      true
    elsif scenario_highlight.scenario_result.scenario.nil?
      researcher == scenario_highlight.scenario_result.created_by
    else
      researcher == scenario_highlight.scenario_result.scenario.created_by
    end
  end
end
