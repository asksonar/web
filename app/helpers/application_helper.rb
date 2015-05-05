module ApplicationHelper

  def drafts_count
    Scenario.drafts(current_researcher.id).count
  end

end
