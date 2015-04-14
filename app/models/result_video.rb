class ResultVideo < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :scenario_result
  has_many :video_transcriptions, inverse_of: :result_video
  delegate :user, :to => :scenario_result, :allow_nil => true

  def share_link
    '/share/videos/' + hashid
  end

  def transcription_array
    VideoTranscription.select(:offset, :text)
      .where(result_video: self)
      .order(offset: :asc)
  end

end
