class ResponsesJsonController < ApplicationController
  before_action :authenticate_researcher!

  attr_writer :responses_query

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end

  def index
    responseParams = {}
    responseParams[:created_by] = current_researcher.id
    responseParams[:created_since] = params[:created_since]

    @result_steps = responses_query
      .responses(responseParams)
      .map(&:list_json)

    render json: @result_steps
  end
end
