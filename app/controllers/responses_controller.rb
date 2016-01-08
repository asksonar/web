class ResponsesController < ApplicationController
  protect_from_forgery with: :null_session
  layout 'plain'

  def create
    uuid = service.handle_touch(touch_params)
    if uuid
      render json: { uuid: uuid }
    else
      render json: { ok: true }
    end
  end

  def unsubscribe
    @prezi = ResponsesPresenter.new(uuid)
    service.dismiss_response(uuid)
    responders_service.unsubscribe!(@prezi.responder)
    render :unsubscribe
  end

  def show
    # will default to render :show unless these functions say otherwise
    if params.key?(:unsubscribe)
      unsubscribe
    else
      update
    end
  end

  def update
    @prezi = ResponsesPresenter.new(uuid)
    if params[:button] == 'submit'
      service.update_response(uuid, update_params)
    end
    respond_to do |format|
      format.html { params.key?(:rating) ? (render :update_rating) : (render :update_success) }
      format.json { render json: { ok: true } }
    end
  end

  def destroy
    service.dismiss_response(uuid)
    render json: { ok: true }
  end

  private

  def uuid
    params[:id]
  end

  def touch_params
    {
      company_uuid: params[:company_uuid],
      email: params[:email],
      date_yyyymmdd: params[:date_yyyymmdd],
      ip_address: request.remote_ip
    }
  end

  def update_params
    {
      rating: params[:rating], # optional
      text: params[:text] # optional
    }
  end

  def service
    @service ||= ResponsesService.instance
  end

  def responders_service
    @responders_service ||= RespondersService.instance
  end

  def responders_query
    @responders_query ||= RespondersQuery.instance
  end
end
