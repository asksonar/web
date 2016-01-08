class ResponsesController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    uuid = service.handle_touch(touch_params)
    if uuid
      render json: { uuid: uuid }
    else
      render json: { ok: true }
    end
  end

  def unsubscribe
    uuid = params[:id]
    @prezi = ResponsesPresenter.new(uuid)
    service.dismiss_response(uuid)
    responders_service.unsubscribe!(@prezi.responder)
    render :unsubscribe
  end

  def show
    if params.has_key?(:unsubscribe)
      return unsubscribe
    end

    uuid = params[:id]
    service.update_response(uuid, update_params)
    respond_to do |format|
      format.html
      format.json { render json: { ok: true } }
    end
  end

  def update
    uuid = params[:id]
    service.update_response(uuid, update_params)
    render json: { ok: true }
  end

  def destroy
    uuid = params[:id]
    service.dismiss_response(uuid)
    render json: { ok: true }
  end

  private

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
