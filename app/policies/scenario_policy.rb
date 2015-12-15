class ScenarioPolicy < ApplicationPolicy
  attr_reader :researcher, :scenario

  def initialize(researcher, scenario)
    @researcher = researcher
    @scenario = scenario
  end

  def show?
    is_super_admin? or is_owner?
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
    researcher == scenario.created_by
  end
end
