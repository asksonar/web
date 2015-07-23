class ResultStep < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :scenario_result
  delegate :panelist, :to => :scenario_result, :allow_nil => true
  has_many :step_feelings, -> { order feeling_at_seconds: :asc }, inverse_of: :result_step
  has_many :step_highlights, -> { order offset_seconds: :asc }, inverse_of: :result_step
  has_many :step_videos, -> { order offset_seconds: :asc }, inverse_of: :result_step
  has_many :step_transcriptions, -> { order offset: :asc }, inverse_of: :result_step
  enum status: [:pending, :uploaded]

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

  def share_link
    Rails.configuration.properties['web_base_url'] +  '/share/videos/' + hashid
  end

  def feelings_delighted
    feelings.where(feeling: StepFeeling.feelings[:delighted])
  end

  def total_delighted
    feelings_delighted.count
  end

  def has_delighted?
    total_delighted > 0
  end

  def feelings_confused
    feelings.where(feeling: StepFeeling.feelings[:confused])
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
    step_transcriptions
  end

  def transcription_array
    transcriptions.select(:offset, :text)
  end

  def first_transcription_text
    !transcriptions.nil? && !transcriptions.first.nil? ? transcriptions.first.text : nil
  end

  def transcription_at(seconds)
    current_transcription = nil

    transcriptions.select(:offset, :text).each do |transcription|
      if transcription.offset <= seconds
        current_transcription = transcription['text']
      else
        break
      end
    end

    return current_transcription
  end

end
