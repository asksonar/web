class StepVideo < ActiveRecord::Base
  belongs_to :result_step
  belongs_to :scenario_result
  belongs_to :scenario_step

  HASHIDS_SALT = 'Akn94V3&%9Tu'
  VIDEO_BASE = Rails.configuration.properties['video_base_url']

  def src_array
    [
      { type: "video/mp4", src: "#{VIDEO_BASE}/#{hashid}/video.mp4" },
      { type: "video/webm", src: "#{VIDEO_BASE}/#{hashid}/video.webm" }
      #{ type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end

end
