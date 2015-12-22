class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def default?
    is_super_admin? or is_owner?
  end

  def is_super_admin?
    user.super_admin?
  end

  def is_owner?
    user == record.prezi.created_by
  end
end
