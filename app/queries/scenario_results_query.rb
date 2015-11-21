class ScenarioResultsQuery
  include Singleton

  def my_feedback(extra_where = {})
    ScenarioResult
      .joins(:result_videos_uploaded)
      .distinct
      .where(extra_where)
      .order(created_at: :desc)
  end

  def my_feedback_paged(page, page_size, extra_one = false, extra_where = {})
    my_feedback(extra_where)
      .limit(page_size + (extra_one ? 1 : 0))
      .offset(page * page_size)
  end

  def count_newer_than(result, extra_where = {})
    my_feedback(extra_where).where('scenario_results.created_at > ?', result.created_at).count
  end
end
