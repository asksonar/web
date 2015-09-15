module ApplicationHelper

  def drafts_count
    ScenariosService.instance.drafts(current_researcher.id).count
  end

end
