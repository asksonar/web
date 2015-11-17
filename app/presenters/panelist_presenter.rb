class PanelistPresenter < SimpleDelegator
  def email
    if super.blank?
      'anonymous'
    else
      super
    end
  end
end
