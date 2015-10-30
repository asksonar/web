class HighlightsService
  include Singleton

  # expecting highlight_params of the form something like
  # {"title"=>"", "video_time_start"=>"0:00", "video_time_end"=>"0:06", "note"=>{"M0JEPob7"=>"on", "nP2x424Q"=>"on"}}
  def create(highlight_params, scenario, result_step)
    ScenarioHighlight.create(
      title: highlight_params[:title],
      start_seconds: highlight_params[:start_seconds],
      end_seconds: highlight_params[:end_seconds],
      timeline_elements: {
        notes: highlight_params[:note].try(:keys),
        transcripts: highlight_params[:transcript].try(:keys)
      }.to_json,
      scenario: scenario,
      result_step: result_step
    )
  end

  def update(highlight, highlight_params)
    highlight.update(
      title: highlight_params[:title],
      start_seconds: highlight_params[:start_seconds],
      end_seconds: highlight_params[:end_seconds],
      timeline_elements: {
        notes: highlight_params[:note].try(:keys),
        transcripts: highlight_params[:transcript].try(:keys)
      }.to_json
    )
  end

  def destroy(highlight)
    highlight.destroy
  end
end
