class ResponsesController < ApplicationController
  before_action :authenticate_researcher!

  attr_writer :responses_query

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end

  def index
    responseParams = {}
    responseParams[:created_by] = current_researcher.id
    @result_steps = responses_query.responses(responseParams)
  end
end
