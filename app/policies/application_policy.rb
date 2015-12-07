class ApplicationPolicy
  attr_reader :researcher, :record

  def initialize(researcher, record)
    @researcher = researcher
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    researcher.super_admin? or researcher == scenario.created_by
  end

  def edit?
    update?
  end

  def destroy?
    researcher.super_admin? or researcher == scenario.created_by
  end

  def scope
    Pundit.policy_scope!(researcher, record.class)
  end

  class Scope
    attr_reader :researcher, :scope

    def initialize(researcher, scope)
      @researcher = researcher
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
