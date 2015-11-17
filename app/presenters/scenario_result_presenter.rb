class ScenarioResultPresenter < SimpleDelegator
  VIDEO_BASE = Rails.configuration.properties['video_base_url']

  def public_json
    {
      hashid: hashid,
      srcArray: src_array,
      shareLink: share_link,
      email: email,
      transcriptionArray: transcription_array,
      highlightedArray: highlighted_array
    }
  end

  def list_json
    {
      result_video_path: result_video_url,
      email: email,
      scenario_step_count: scenario_step_count,
      scenario_title: scenario_title
    }
  end

  def result_step_offset_seconds(scenario_step)
    result_step = result_steps.find_by_scenario_step_id(scenario_step)
    result_step.offset_seconds
  end

  def my_feedback?
    scenario.nil?
  end

  def title
    if scenario
      scenario.title
    elsif super.blank?
      'untitled feedback'
    else
      super
    end
  end

  def email
    if scenario
      panelist.prezi.email
    else
      created_by.email
    end
  end

  def src_array
    return nil if result_videos_uploaded.first.nil?

    hashid = result_videos_uploaded.first.hashid

    [
      { type: 'video/mp4', src: "#{VIDEO_BASE}/#{hashid}/video.mp4" },
      { type: 'video/webm', src: "#{VIDEO_BASE}/#{hashid}/video.webm" }
      # { type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end

  def share_link
    Rails.configuration.properties['web_base_url'] + '/share/videos/' + hashid
  end

  def highlighted_array
    result_notes.select(:id, :offset_seconds, :text).map do |result_note|
      {
        hashid: result_note.hashid,
        time: result_note.offset_seconds,
        text: result_note.text
      }
    end
    # highlights.map { |highlight| highlight.offset_seconds }
  end

  def transcription_array
    result_transcriptions.select(:id, :offset_seconds, :text).map do |result_transcription|
      {
        hashid: result_transcription.hashid,
        time: result_transcription.offset_seconds,
        text: result_transcription.text
      }
    end
  end

  def scenario
    super.try(:prezi)
  end

  def scenario_title
    scenario.title
  end

  def scenario_step_count
    scenario.step_count
  end

  def result_video_url
    Rails.application.routes.url_helpers.result_video_path(scenario, self)
  end
end
