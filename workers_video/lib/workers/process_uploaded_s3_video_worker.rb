require 'helpers/ff_mpeg_helper'
require 'helpers/s3_helper'

module Workers
  class ProcessUploadedS3VideoWorker
    @queue = :video_s3

    def self.perform(uuid)
      byebug

      step_videos = StepVideo.where(uuid: uuid)
      if step_videos.count == 0
        return
      end

      # cache all the files we need
      file = Tempfile.new(uuid)
      begin
        process_s3_video(uuid, file.path)

        step_videos.each do |step_video|
          process_step_video(
            uuid,
            file.path,
            step_video.hashid,
            step_video.offset_seconds,
            step_video.length_seconds
          )
          step_video.result_step.status = "uploaded"
          step_video.result_step.save
        end
      ensure
        file.close
        file.unlink
      end
    end

    def self.process_s3_video(uuid, local_path)
      byebug

      s3_helper = Helpers::S3Helper.new
      s3_helper.download_video(uuid, local_path)
      s3_helper.backup_video(uuid)
      # s3_helper.delete_video(uuid)
    end

    def self.process_step_video(uuid, local_path, target_path, offset_seconds, length_seconds)
      byebug

      mp4_file = Tempfile.new(uuid + '.mp4')
      webm_file = Tempfile.new(uuid + '.webm')

      begin
        Helpers::FfMpegHelper.webm_to_mp4_webm(local_path, offset_seconds, length_seconds, mp4_file.path, webm_file.path)

        s3_helper = Helpers::S3Helper.new
        s3_helper.upload_video(mp4_path, target_path + '/' + uuid + '.mp4', 'video/mp4')
        s3_helper.upload_video(webm_path, target_path + '/' + uuid + '.webm', 'video/webm')
      ensure
        mp4_file.close
        mp4_file.unlink
        webm_file.close
        webm_file.unlink
      end
    end
  end
end
