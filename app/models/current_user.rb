class CurrentUser

  def initialize(user_or_researcher)
    @user_or_researcher = user_or_researcher
  end

  def display
    @user_or_researcher.class.name + ' ' + @user_or_researcher.id.to_s
  end

  def isUser?
    defined? @user_or_researcher.isUser? and @user_or_researcher.isUser?
  end

  def isResearcher?
    defined? @user_or_researcher.isResearcher? and @user_or_researcher.isResearcher?
  end

end
