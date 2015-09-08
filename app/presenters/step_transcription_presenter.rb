class StepTranscriptionPresenter < SimpleDelegator
  def public_json
    {
      hashid: hashid,
      timeSeconds: offset_seconds,
      text: text
    }
  end
end
