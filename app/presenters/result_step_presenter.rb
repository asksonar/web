class ResultStepPresenter < SimpleDelegator
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

  def src_array
    step_videos.first && step_videos.first.src_array
  end

  def share_link
    Rails.configuration.properties['web_base_url'] + '/share/videos/' + hashid
  end

  def delighted_array
    feelings_delighted.select(:id, :feeling_at_seconds).map do |feeling|
      {
        hashid: StepFeeling.hashids.encode(feeling.id),
        time: feeling.feeling_at_seconds
      }
    end
  end

  def confused_array
    feelings_confused.select(:id, :feeling_at_seconds).map do |feeling|
      {
        hashid: StepFeeling.hashids.encode(feeling.id),
        time: feeling.feeling_at_seconds
      }
    end
  end

  def highlighted_array
    # highlights.map { |highlight| highlight.offset_seconds }
  end

  def transcription_array
    transcriptions.select(:id, :offset_seconds, :text).map do |transcription|
      {
        hashid: StepTranscription.hashids.encode(transcription.id),
        time: transcription.offset_seconds,
        text: transcription.text
      }
    end
  end
end
