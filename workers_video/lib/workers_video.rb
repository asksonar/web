require "workers_video/version"
require "workers/process_uploaded_s3_video_worker"

module WorkersVideo
  require 'workers_video/railtie' if defined?(Rails)

  def self.process_uploaded_s3_video_async(uuid)
    Resque.enqueue(Workers::ProcessUploadedS3VideoWorker, uuid)
  end
end
