require 'aws-sdk'

class S3Utility
  S3_VIDEOS_BUCKET = Rails.configuration.properties['s3_videos_bucket']
  S3_UPLOAD_BUCKET = Rails.configuration.properties['s3_upload_bucket']
  S3_BACKUP_BUCKET = Rails.configuration.properties['s3_backup_bucket']

  def s3
    @s3_resource ||= Aws::S3::Resource.new(
      region: Rails.configuration.properties['s3_region'],
      credentials: Aws::Credentials.new(
        Rails.configuration.properties['s3_access_key'],
        Rails.configuration.properties['s3_secret_key']
      )
    )
  end

  def list(bucket, path_prefix)
    s3.bucket(bucket).objects(
      prefix: path_prefix
    )
  end

  def list_video(path_prefix)
    list(S3_VIDEOS_BUCKET, path_prefix)
  end

  def copy(from_bucket, from_bucket_path, to_bucket, to_bucket_path)
    s3.bucket(to_bucket).object(to_bucket_path)
      .copy_from(
        copy_source: "#{from_bucket}/#{from_bucket_path}"
      )
    Rails.logger.info "backed up from: #{from_bucket}/#{from_bucket_path} to: #{to_bucket}/#{to_bucket_path}"
  end

  def copy_video(from_bucket_path, to_bucket_path)
    copy(S3_VIDEOS_BUCKET, from_bucket_path, S3_VIDEOS_BUCKET, to_bucket_path)
  end
end
