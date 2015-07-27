class ProcessUploadedS3VideoWorker
  @queue = :video_s3

  def self.perform(uuid)
  end
end
