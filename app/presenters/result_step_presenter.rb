class ResultStepPresenter < SimpleDelegator
  VIDEO_BASE = Rails.configuration.properties['video_base_url']

  def public_json
    {
      hashid: hashid,
      srcArray: src_array,
      shareLink: share_link,
      email: email,
      transcriptionArray: transcription_array,
      delightedArray: delighted_array,
      confusedArray: confused_array,
      highlightedArray: highlighted_array
    }
  end

  def email
    if panelist.email.empty?
      'anonymous'
    else
      panelist.email
    end
  end

  def src_array
    return nil if step_videos.first.nil?

    hashid = step_videos.first.hashid

    [
      { type: 'video/mp4', src: "#{VIDEO_BASE}/#{hashid}/video.mp4" },
      { type: 'video/webm', src: "#{VIDEO_BASE}/#{hashid}/video.webm" }
      # { type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
    ]
  end

  def share_link
    Rails.configuration.properties['web_base_url'] + '/share/videos/' + hashid
  end

  def delighted_array
    feelings_delighted.select(:id, :feeling_at_seconds).map do |feeling|
      {
        hashid: feeling.hashid,
        time: feeling.feeling_at_seconds
      }
    end
  end

  def confused_array
    feelings_confused.select(:id, :feeling_at_seconds).map do |feeling|
      {
        hashid: feeling.hashid,
        time: feeling.feeling_at_seconds
      }
    end
  end

  def highlighted_array
    notes.select(:id, :offset_seconds, :text).map do |note|
      {
        hashid: note.hashid,
        time: note.offset_seconds,
        text: note.text
      }
    end
    # highlights.map { |highlight| highlight.offset_seconds }
  end

  def transcription_array
    transcriptions.select(:id, :offset_seconds, :text).map do |transcription|
      {
        hashid: transcription.hashid,
        time: transcription.offset_seconds,
        text: transcription.text
      }
    end
  end

  def scenario_title
    scenario.title
  end

  def scenario_step_count
    scenario.step_count
  end
end
