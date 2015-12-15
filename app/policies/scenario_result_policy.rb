class ScenarioResultPolicy < ApplicationPolicy
  attr_reader :researcher, :scenario_result

  def initialize(researcher, scenario_result)
    @researcher = researcher
    @scenario_result = scenario_result
  end

  def show?
    is_super_admin? or is_owner?
  end

  def new_highlight?
    is_super_admin? or is_owner?
  end

  def create_highlight?
    is_super_admin? or is_owner?
  end

  def create_note?
    is_super_admin? or is_owner?
  end

  private

  def is_super_admin?
    researcher.super_admin?
  end

  def is_owner?
    if scenario_result.scenario.nil?
      researcher == scenario_result.created_by
    else
      researcher == scenario_result.scenario.created_by
    end
  end
end
