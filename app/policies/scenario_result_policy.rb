class ScenarioResultPolicy < ApplicationPolicy
  attr_reader :researcher, :scenario_result

  def initialize(researcher, scenario_result)
    @researcher = researcher
    @scenario_result = scenario_result
  end

  def new_highlight?
    if researcher.super_admin?
      true
    elsif scenario_result.scenario.nil?
      researcher == scenario_result.created_by
    else
      researcher == scenario_result.scenario.created_by
    end
  end

  def create_highlight?
    if researcher.super_admin?
      true
    elsif scenario_result.scenario.nil?
      researcher == scenario_result.created_by
    else
      researcher == scenario_result.scenario.created_by
    end
  end

  def create_note?
    if researcher.super_admin?
      true
    elsif scenario_result.scenario.nil?
      researcher == scenario_result.created_by
    else
      researcher == scenario_result.scenario.created_by
    end
  end

  def show?
    researcher.super_admin? or researcher == scenario_result.created_by
  end
end
