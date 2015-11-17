class PanelistPresenter < SimpleDelegator
  def email
    if super.empty?
      'anonymous'
    else
      super
    end
  end
end
