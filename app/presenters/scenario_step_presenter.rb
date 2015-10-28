class ScenarioStepPresenter < SimpleDelegator
  MAX_TIME_BUCKET = 180

  def public_json
    {
      stepDescription: description,
      stepOrder: step_order
    }
  end

  def newest_result_steps
    __getobj__.result_steps.order(created_at: :desc).map(&:prezi)
  end

  def average_completed_minutes
    Time.at(result_steps.average(:completed_seconds) || 0).strftime("%-Mm %-Ss")
  end

  def result_time_bucket_hash
    buckets = {}
    (0..MAX_TIME_BUCKET).step(30) do |i|
        buckets[i] = {};
        buckets[i][:display] = Time.at(i).strftime("%-M:%S")
        buckets[i][:display] += '+' if i == MAX_TIME_BUCKET
        buckets[i][:details] = []
        buckets[i][:count] = 0
    end

    #buckets = {
    #  '0:00':[], '0:30':[], '1:00':[], '1:30':[], '2:00':[], '2:30':[], '3:00+':[]
    #}
    result_steps.each do |result|
      bucket_time = [result.completed_seconds.to_i, MAX_TIME_BUCKET].min
      bucket_time = (bucket_time / 30) * 30

      buckets[bucket_time][:details] += [{id: result.id, step_id: result.scenario_step_id, time: result.completed_seconds}]
      buckets[bucket_time][:count] += 1
    end

    return buckets
  end

end
