class ResultVideo < ActiveRecord::Base
  VIDEO_BASE = Rails.configuration.properties['video_base_url']

  belongs_to :scenario_step
  belongs_to :scenario_result
  delegate :panelist, :to => :scenario_result, :allow_nil => true

  def share_link
    Rails.configuration.properties['web_base_url'] +  '/share/videos/' + hashid
  end

  def src_array
    # return [ { type: "video/mp4", src: "http://vjs.zencdn.net/v/oceans.mp4" } ]

    [
      { type: "video/mp4", src: "#{VIDEO_BASE}/#{scenario_result.hashid}/#{hashid}.mp4" },
      { type: "video/webm", src: "#{VIDEO_BASE}/#{scenario_result.hashid}/#{hashid}.webm" }
      #{ type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end

end
