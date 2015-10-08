class StepVideo < ActiveRecord::Base
  belongs_to :result_step
  belongs_to :scenario_result
  belongs_to :scenario_step

  HASHIDS_SALT = 'Akn94V3&%9Tu'

  def generate_new_sample_result(new_result_step)
    new_step_video = self.dup
    new_step_video.result_step = new_result_step
    new_step_video.save

    s3_utility = S3Utility.new

    s3_utility.list_video(hashid).each do |object_summary|
      path_ending = object_summary.key.sub(hashid,'')
      s3_utility.copy_video(object_summary.key, new_step_video.hashid + path_ending)
    end
  end
end
