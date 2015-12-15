class ResultNotePolicy < ApplicationPolicy
  attr_reader :researcher, :record

  def initialize(researcher, record)
    @researcher = researcher
    @record = record
  end

  alias update? default?
  alias destroy? default?
end
