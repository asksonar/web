class ScenarioResultPresenter < SimpleDelegator
  VIDEO_BASE = Rails.configuration.properties['video_base_url']

  def email
    if panelist.email.empty?
      'anonymous'
    else
      panelist.email
    end
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

end