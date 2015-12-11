class NotesController < ApplicationController
  def create
    scenario_result = ScenarioResult.find_by_hashid(params[:scenario_result_hashid])
    result_note = service.create(scenario_result, note_params)
    json = result_note.prezi.public_json
    render json: json
  end

  def update
    result_note = ResultNote.find_by_hashid!(params[:id])
    result_note = service.update(result_note, note_params)
    json = result_note.prezi.public_json
    render json: json
  end

  def destroy
    result_note = ResultNote.find_by_hashid!(params[:id])
    service.destroy(result_note)
    render plain: 'OK'
  end

  private

  def service
    @service ||= ResultNotesService.instance
  end

  def note_params
    {
      offset_seconds: params[:time],
      text: params[:text]
    }
  end
end
