class ScenarioResultPresenter < SimpleDelegator

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