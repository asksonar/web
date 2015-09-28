class ResultStep < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :scenario_result
  has_many :step_feelings, -> { order feeling_at_seconds: :asc }, inverse_of: :result_step
  has_many :step_highlights, -> { order offset_seconds: :asc }, inverse_of: :result_step
  has_many :step_notes, -> { order offset_seconds: :asc }, inverse_of: :result_step
  has_many :step_videos, -> { order offset_seconds: :asc }, inverse_of: :result_step
  has_many :step_transcriptions, -> { order offset_seconds: :asc }, inverse_of: :result_step
  enum status: [:pending, :uploaded]

  delegate :panelist, to: :scenario_result
  delegate :email, to: :scenario_result
  delegate :scenario, to: :scenario_result

  HASHIDS_SALT = '4$g&QNrACfVp'

  def video
    # TODO: handle case where we have multiple videos for a result_step
    step_videos.first
  end

  def feelings
    step_feelings
  end

  def highlights
    step_highlights
  end

  def feelings_delighted
    feelings.delighted
  end

  def has_delighted?
    total_delighted > 0
  end

  def feelings_confused
    feelings.confused
  end

  def has_confused?
    total_confused > 0
  end

  def transcriptions
    step_transcriptions
  end

  def transcription_at(seconds)
    current_transcription = nil

    transcriptions.select(:offset_seconds, :text).each do |transcription|
      if transcription.offset_seconds <= seconds
        current_transcription = transcription['text']
      else
        break
      end
    end

    current_transcription
  end

  def notes
    step_notes
  end

  def link_videos
    StepVideo.where(
      scenario_result: scenario_result,
      scenario_step: scenario_step
    ).update_all(result_step_id: id)
  end

  def generate_new_sample_result(new_scenario_step, new_scenario_result)
    new_result_step = dup
    new_result_step.scenario_step = new_scenario_step
    new_result_step.scenario_result = new_scenario_result
    new_result_step.save

    step_feelings.each do |step_feeling|
      step_feeling.generate_new_sample_result(new_result_step)
    end
    step_highlights.each do |step_highlight|
      step_highlight.generate_new_sample_result(new_result_step)
    end
    step_videos.each do |step_video|
      step_video.generate_new_sample_result(new_result_step)
    end
    step_transcriptions.each do |step_transcription|
      step_transcription.generate_new_sample_result(new_result_step)
    end
  end
end
