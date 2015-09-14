class NotesController < ApplicationController
  attr_writer :service

  def service
    @service ||= StepNotesService.instance
  end

  def create
    step_note = service.create_from_result_step_hashid(
      result_step_hashid: params[:result_step_hashid],
      offset_seconds: params[:time],
      text: params[:text]
    )
    json = StepNotePresenter.new(step_note).public_json
    render json: json
  end

  def update
    step_note = service.update_from_hashid(
      hashid: params[:id],
      offset_seconds: params[:time],
      text: params[:text]
    )

    json = StepNotePresenter.new(step_note).public_json
    render json: json
  end

  def destroy
    service.destroy_from_hashid(params[:id])
    render plain: 'OK'
  end
end
