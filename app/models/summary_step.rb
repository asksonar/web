class SummaryStep

  MAX_TIME_BUCKET=180

  def initialize(scenario_step)
    @scenario_step = scenario_step
  end

  def step_order
    @scenario_step.step_order
  end

  def description
    @scenario_step.description
  end

  def average_completed_seconds
    @scenario_step.scenario_step_results.average(:completed_seconds)
  end

  def result_time_hash
    @scenario_step.scenario_step_results.map { |result|
      { id: result.id, time: result.completed_seconds }
    }
  end

  def result_time_bucket_hash
    buckets = {}
    (0..MAX_TIME_BUCKET).step(30) do |i|
        min = i / 60
        seconds = i % 60
        buckets[i] = {};
        buckets[i][:display] = min.to_s + ':' + seconds.to_s.rjust(2, '0')
        buckets[i][:display] += '+' if i == MAX_TIME_BUCKET
        buckets[i][:details] = []
        buckets[i][:count] = 0
    end

    #buckets = {
    #  '0:00':[], '0:30':[], '1:00':[], '1:30':[], '2:00':[], '2:30':[], '3:00+':[]
    #}
    @scenario_step.scenario_step_results.each do |result|
      bucket_time = [result.completed_seconds, MAX_TIME_BUCKET].min
      bucket_time = (bucket_time / 30) * 30

      buckets[bucket_time][:details] += [{id: result.id, time: result.completed_seconds}]
      buckets[bucket_time][:count] += 1
    end

    return buckets
  end

  def delighted_feelings
    @scenario_step.where_feeling_delighted || []
  end

  def frustrated_feelings
    @scenario_step.where_feeling_confused || []
  end

end
