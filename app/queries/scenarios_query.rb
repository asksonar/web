class ScenariosQuery
  include Singleton

  def drafts(created_by)
    Scenario
      .where(status: Scenario.statuses[:drafts])
      .where(created_by: created_by)
      .order(updated_at: :desc)
  end

  def results(extra_where = {})
    Scenario
      .where(status: [Scenario.statuses[:live], Scenario.statuses[:completed]])
      .where(extra_where)
      .order(published_at: :desc)
  end

  # page index is 0-based
  def results_paged(page, page_size, extra_one = false, extra_where = {})
    results(extra_where)
      .limit(page_size + (extra_one ? 1 : 0))
      .offset(page * page_size)
  end
end
