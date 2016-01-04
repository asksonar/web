class ResponsesController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  protect_from_forgery with: :null_session, except: [:index]

  def index
    @scenario_results = query
      .responses(company: current_user.company)
      .map(&:prezi)
  end

  def create
    response_params = service.handle_touch(touch_params)
    if response_params[:uuid]
      render json: { uuid: response_params[:uuid], style_elements: response_params[:style_elements]  }
    else
      render json: { ok: true }
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

  def query
    @query ||= ScenarioResultsQuery.instance
  end

  def service
    @service ||= ResponsesService.instance
  end
end
