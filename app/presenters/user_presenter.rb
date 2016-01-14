class UserPresenter < SimpleDelegator
  def inviter
    inviter = User.find_by_id(invited_by_id)
    inviter.full_name
  end

  def is_admin?
    admin? || super_admin?
  end
end
