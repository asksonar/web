module DefaultTextHelper
  def dt_transcription(transcription)
    if transcription.nil?
      '(no transcription)'
    else
      transcription
    end

  end
end
