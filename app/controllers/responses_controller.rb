class ResponsesController < ApplicationController
  protect_from_forgery with: :null_session
  layout 'plain'

  def create
    response_params = service.handle_touch(touch_params)
    if response_params[:uuid]
      render json: response_params
    else
      render json: { ok: true }
    end
  end

  def unsubscribe
    service.unsubscribe_response(uuid)
    @prezi = ResponsesPresenter.new(uuid)
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
    if params[:button] == 'submit'
      service.update_response(uuid, update_params)
    end
    respond_to do |format|
      format.html do
        @prezi = ResponsesPresenter.new(uuid)
        if params.key?(:rating)
          render :update_rating
        else
          render :update_success
        end
      end
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
end
