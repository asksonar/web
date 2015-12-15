class ResultNotePolicy < ApplicationPolicy
  attr_reader :researcher, :result_note

  def initialize(researcher, result_note)
    @researcher = researcher
    @result_note = result_note
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
    if result_note.scenario_result.scenario.nil?
      researcher == result_note.scenario_result.created_by
    else
      researcher == result_note.scenario_result.scenario.created_by
    end
  end
end
