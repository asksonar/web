module ApplicationHelper

  def drafts_count
    ScenariosQuery.instance.drafts(current_user.id).count
  end

end
