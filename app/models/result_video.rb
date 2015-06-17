class ResultVideo < ActiveRecord::Base
  VIDEO_BASE = Rails.configuration.properties['video_base_url']

  belongs_to :scenario_step
  belongs_to :scenario_result
  has_many :video_transcriptions, -> { order offset: :asc }, inverse_of: :result_video
  delegate :panelist, :to => :scenario_result, :allow_nil => true

  def share_link
    Rails.configuration.properties['web_base_url'] +  '/share/videos/' + hashid
  end

  def transcription_array
    video_transcriptions.select(:offset, :text)
  end

  def src_array
    #return [ { type: "video/mp4", src: "http://vjs.zencdn.net/v/oceans.mp4" } ]

    [
      { type: "video/mp4", src: "#{VIDEO_BASE}/#{scenario_result.hashid}/#{hashid}.mp4" },
      { type: "video/webm", src: "#{VIDEO_BASE}/#{scenario_result.hashid}/#{hashid}.mp4" }
      #{ type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end

  def transcription_start
    video_transcriptions.first.text
  end

end
