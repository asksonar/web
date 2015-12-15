class ScenarioResultPolicy < ApplicationPolicy
  attr_reader :researcher, :record

  def initialize(researcher, record)
    @researcher = researcher
    @record = record
  end

  alias show? default?
  alias new_highlight? default?
  alias create_highlight? default?
  alias create_note? default?
end
