require 'aws-sdk'

module Helpers
  class S3Helper
    S3_UPLOAD_TO_BUCKET = 'videos.dev.asksonar'
    S3_DOWNLOAD_FROM_BUCKET = 'upload.videos.asksonar'
    S3_BACKUP_FOLDER = 'originals'

    def s3
      s3_resource ||= Aws::S3::Resource.new(
        region: 'us-west-1',
        credentials: Aws::Credentials.new('AKIAJ43WUACRCS56MEQA', 'zCXvi5lF2EY9nZdsHDr1LTuXs2WgI1H5CgPjSh+f')
      )
    end

    def upload_video(local_path, target_path, content_type)
      p 'uploading from: ' + local_path + ' to: ' + S3_UPLOAD_TO_BUCKET + '/' + target_path
      bucket = s3.bucket(S3_UPLOAD_TO_BUCKET)
      object = bucket.object(target_path)
      if object.upload_file(local_path, { content_type: content_type })
        p 'Uploaded file to s3: ' + target_path
      else
        raise 'Failed to upload to s3: ' + target_path
      end
    end

    def download_video(from_download_bucket_path, to_local_path)
      p 'downloading from: ' + S3_DOWNLOAD_FROM_BUCKET + '/' + from_download_bucket_path + ' to: ' + to_local_path
      bucket = s3.bucket(S3_DOWNLOAD_FROM_BUCKET)
      object = bucket.object(from_download_bucket_path)
      object.get({
        response_target: to_local_path
      })
      p 'downloaded from: ' + S3_DOWNLOAD_FROM_BUCKET + '/' + from_download_bucket_path + ' to: ' + to_local_path
    end

    def backup_video(from_download_bucket_path)
      copy_video(from_download_bucket_path, S3_BACKUP_FOLDER + '/' + from_download_bucket_path)
    end

    def copy_video(from_download_bucket_path, to_upload_bucket_path)
      p 'copying from: ' + S3_DOWNLOAD_FROM_BUCKET + '/' + from_download_bucket_path + ' to: ' + S3_UPLOAD_TO_BUCKET + '/' + to_upload_bucket_path
      bucket = s3.bucket(S3_UPLOAD_TO_BUCKET)
      object = bucket.object(to_upload_bucket_path)
      object.copy_from({
        copy_source: S3_DOWNLOAD_FROM_BUCKET + '/' + from_download_bucket_path
      })
      p 'copied from: ' + S3_DOWNLOAD_FROM_BUCKET + '/' + from_download_bucket_path + ' to: ' + S3_UPLOAD_TO_BUCKET + '/' + to_upload_bucket_path
    end

    def delete_video(from_download_bucket_path)
      bucket = s3.bucket(S3_DOWNLOAD_FROM_BUCKET)
      object = bucket.object(from_download_bucket_path)
      object.delete
    end

  end
end
