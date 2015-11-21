class ResponsesController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @scenario_results = responses_query
      .responses(company: current_researcher.company)
      .map(&:prezi)
  end

  private

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end
end
