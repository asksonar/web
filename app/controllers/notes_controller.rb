class NotesController < ApplicationController
  def create
    result_note = service.create_from_scenario_result_hashid(
      scenario_result_hashid: params[:scenario_result_hashid],
      offset_seconds: params[:time],
      text: params[:text]
    )
    json = result_note.prezi.public_json
    render json: json
  end

  def update
    result_note = service.update_from_hashid(
      hashid: params[:id],
      offset_seconds: params[:time],
      text: params[:text]
    )

    json = result_note.prezi.public_json
    render json: json
  end

  def destroy
    service.destroy_from_hashid(params[:id])
    render plain: 'OK'
  end

  private

  def service
    @service ||= ResultNotesService.instance
  end
end
