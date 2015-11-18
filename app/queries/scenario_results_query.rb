class ScenarioResultsQuery
  include Singleton

  def my_feedback(extra_where = {})
    ScenarioResult
      .joins(:result_videos_uploaded)
      .distinct
      .where(extra_where)
      .order(created_at: :desc)
  end

  def my_feedback_paged(page, page_size, extra_where = {})
    my_feedback(extra_where)
      .limit(page_size)
      .offset(page * page_size)
  end

  def count_newer_than(result)
    ScenarioResult.where('created_at > ?', result.created_at).count
  end
end
