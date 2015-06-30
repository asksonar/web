class ResultStep < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :panelist
  belongs_to :scenario_result

  def video
    ResultVideo.find_by(scenario_step: scenario_step, scenario_result: scenario_result)
  end

  def feelings
    ResultFeeling.where(scenario_step: scenario_step, scenario_result: scenario_result)
  end

  def highlights
    ResultHighlight.where(scenario_step: scenario_step, scenario_result: scenario_result)
  end

  def feelings_delighted
    feelings.where(feeling: ResultFeeling.feelings[:delighted])
  end

  def total_delighted
    feelings_delighted.count
  end

  def has_delighted?
    total_delighted > 0
  end

  def feelings_confused
    feelings.where(feeling: ResultFeeling.feelings[:confused])
  end

  def total_confused
    feelings_confused.count
  end

  def has_confused?
    total_confused > 0
  end

  def email
    scenario_result.email
  end

  def transcriptions
    video ? video.video_transcriptions : nil
  end

  def first_transcription_text
    !transcriptions.nil? && !transcriptions.first.nil? ? transcriptions.first.text : nil
  end

end
