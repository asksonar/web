class ResultVideo < ActiveRecord::Base
  VIDEO_BASE = 'http://video.asksonar.com/output'

  belongs_to :scenario_step
  belongs_to :scenario_result
  has_many :video_transcriptions, inverse_of: :result_video
  delegate :panelist, :to => :scenario_result, :allow_nil => true

  def share_link
    '/share/videos/' + hashid
  end

  def transcription_array
    VideoTranscription.select(:offset, :text)
      .where(result_video: self)
      .order(offset: :asc)
  end

  def src_array
    [
      { type: "video/mp4", src: "#{VIDEO_BASE}/#{scenario_result.hashid}/#{hashid}.mp4" },
      { type: "video/webm", src: "#{VIDEO_BASE}/#{scenario_result.hashid}/#{hashid}.mp4" }
      #{ type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end


end
