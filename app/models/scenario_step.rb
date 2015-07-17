class ScenarioStep < ActiveRecord::Base
  belongs_to :scenario
  has_many :result_steps, -> { order completed_seconds: :asc }, inverse_of: :scenario_step
  has_many :result_feelings, -> { order feeling_at_seconds: :asc }, inverse_of: :scenario_step
  has_many :result_highlights, -> { order offset_seconds: :asc }, through: :result_steps
  has_many :step_videos, -> { order offset_seconds: :asc }, through: :result_steps

  MAX_TIME_BUCKET=180

  def where_feeling_delighted
    result_feelings.where(feeling: ResultFeeling.feelings[:delighted])
  end

  def where_feeling_confused
    result_feelings.where(feeling: ResultFeeling.feelings[:confused])
  end

  def completed_users
    result_steps.count
  end

  def average_completed_seconds
    result_steps.average(:completed_seconds)
  end

  def average_completed_minutes
    Time.at(result_steps.average(:completed_seconds) || 0).strftime("%-Mm %-Ss")
  end

  def has_results?
    result_steps.count > 0
  end

  def result_time_hash
    result_steps.map { |result|
      { id: result.id, time: result.completed_seconds }
    }
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

  def delighted_feelings
    where_feeling_delighted || []
  end

  def total_delighted
    delighted_feelings.count
  end

  def confused_feelings
    where_feeling_confused || []
  end

  def total_confused
    confused_feelings.count
  end

  def result_steps_newest
    ResultStep.where(scenario_step: self).order(created_at: :desc)
  end

end
