class ApplicationPolicy
  attr_reader :researcher, :record

  def initialize(researcher, record)
    @researcher = researcher
    @record = record
  end

  def default?
    is_super_admin? or is_owner?
  end

  def is_super_admin?
    researcher.super_admin?
  end

  def is_owner?
    researcher == record.prezi.created_by
  end
end
