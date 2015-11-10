class ResponsesController < ApplicationController
  before_action :authenticate_researcher!

  attr_writer :responses_query

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end

  def index
    @scenario_results = responses_query
      .responses(company: current_researcher.company)
      .map(&:prezi)
  end
end
