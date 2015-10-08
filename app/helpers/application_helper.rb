module ApplicationHelper

  def drafts_count
    ScenariosQuery.instance.drafts(current_researcher.id).count
  end

end
