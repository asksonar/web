class UsersQuery
  include Singleton

  def users(company_id)
    User
      .where(company_id: company_id)
      .where(invitation_token: nil)
      .where(deleted_at: nil)
      .order(email: :asc)
  end

  def invited_users(company_id)
    User
      .where(company_id: company_id)
      .where.not(invitation_token: nil)
      .where(invitation_accepted_at: nil)
      .order(email: :asc)
  end
end
