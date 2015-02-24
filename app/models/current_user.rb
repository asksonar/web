class CurrentUser

  def initialize(user_or_researcher)
    @user_or_researcher = user_or_researcher
  end

  def display
    @user_or_researcher.class.name + ' ' + @user_or_researcher.id.to_s
  end

  def is_user?
    defined? @user_or_researcher.is_user? and @user_or_researcher.is_user?
  end

  def is_researcher?
    defined? @user_or_researcher.is_researcher? and @user_or_researcher.is_researcher?
  end

  def user
    @user_or_researcher if is_user?
  end

  def researcher
    @user_or_researcher if is_researcher?
  end

  def company
    @user_or_researcher.company if is_researcher?
  end

end
