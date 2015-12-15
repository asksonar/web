class ResultNotePolicy < ApplicationPolicy
  attr_reader :researcher, :result_note

  def initialize(researcher, result_note)
    @researcher = researcher
    @result_note = result_note
  end

  def update?
    if researcher.super_admin?
      true
    elsif result_note.scenario_result.scenario.nil?
      researcher == result_note.scenario_result.created_by
    else
      researcher == result_note.scenario_result.scenario.created_by
    end
  end

  def destroy?
    if researcher.super_admin?
      true
    elsif result_note.scenario_result.scenario.nil?
      researcher == result_note.scenario_result.created_by
    else
      researcher == result_note.scenario_result.scenario.created_by
    end
  end
end
