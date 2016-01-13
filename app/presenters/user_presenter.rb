class UserPresenter < SimpleDelegator
  def invitor
    invitor = User.find_by_id(invited_by_id)
    invitor.full_name
  end
end
