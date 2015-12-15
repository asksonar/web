class ScenarioPolicy < ApplicationPolicy
  attr_reader :researcher, :record

  def initialize(researcher, record)
    @researcher = researcher
    @record = record
  end

  alias show? default?
  alias edit? default?
  alias update? default?
  alias destroy? default?
end
