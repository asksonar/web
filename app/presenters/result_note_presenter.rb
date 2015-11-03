class ResultNotePresenter < SimpleDelegator
  def public_json
    {
      hashid: hashid,
      time: offset_seconds,
      text: text
    }
  end
end
