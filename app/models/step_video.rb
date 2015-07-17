class StepVideo < ActiveRecord::Base
  belongs_to :result_step

  HASHIDS_SALT = 'Akn94V3&%9Tu'
  VIDEO_BASE = Rails.configuration.properties['video_base_url']

  def src_array
    # return [ { type: "video/mp4", src: "http://vjs.zencdn.net/v/oceans.mp4" } ]

    [
      { type: "video/mp4", src: "#{VIDEO_BASE}/#{hashid}/video.mp4" },
      { type: "video/webm", src: "#{VIDEO_BASE}/#{hashid}/video.webm" }
      #{ type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end

end
