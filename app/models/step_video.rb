class StepVideo < ActiveRecord::Base
  VIDEO_BASE = Rails.configuration.properties['video_base_url']

  belongs_to :result_step
  delegate :panelist, :to => :result_step, :allow_nil => true

  def src_array
    # return [ { type: "video/mp4", src: "http://vjs.zencdn.net/v/oceans.mp4" } ]

    [
      { type: "video/mp4", src: "#{VIDEO_BASE}/#{scenario_result.hashid}/#{hashid}.mp4" },
      { type: "video/webm", src: "#{VIDEO_BASE}/#{scenario_result.hashid}/#{hashid}.webm" }
      #{ type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end

end
