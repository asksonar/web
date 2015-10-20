class ResponsesJsonController < ApplicationController
  before_action :authenticate_researcher!

  attr_writer :responses_query

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end

  def index
    responseParams = {}
    responseParams[:company] = current_researcher.company
    responseParams[:created_since] = Time.zone.parse(params[:startTime])
    @result_steps = responses_query
      .responses(responseParams)
      .map(&:prezi)
      .map(&:list_json)

    render json: @result_steps
  end
end
