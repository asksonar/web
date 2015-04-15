class ResultVideo < ActiveRecord::Base
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
      { type: "video/mp4", src: "http://vjs.zencdn.net/v/oceans.mp4" },
      #{ type: "video/webm", src: "/videos/video_" + data.id + ".webm" },
      #{ type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end


end
