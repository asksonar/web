class ScenariosService
  include Singleton

  def set_live(scenario)
    scenario.status = :live
    scenario.published_at = Time.new
    scenario.save
  end

  def set_completed(scenario)
    scenario.status = :completed
    scenario.completed_at = Time.new
    scenario.save
  end

  def drafts(created_by)
    Scenario
      .where(status: Scenario.statuses[:drafts])
      .where(created_by: created_by)
      .order(updated_at: :desc)
      .map(&:prezi)
  end

  def results(extra_where = {})
    Scenario
      .where(status: [Scenario.statuses[:live], Scenario.statuses[:completed]])
      .where(extra_where)
      .order(published_at: :desc)
      .map(&:prezi)
  end

end
