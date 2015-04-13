class ResultVideo < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :scenario_result
  has_many :video_transcriptions, inverse_of: :result_video
  delegate :user, :to => :scenario_result, :allow_nil => true

  def share_link
    '/share/videos/' + id.to_s
  end

end
