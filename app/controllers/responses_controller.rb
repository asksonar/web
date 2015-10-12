class ResponsesController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @result_steps = ResultStep
      .joins(scenario_step: :scenario)
      .where(scenarios: {created_by: current_researcher.id})
      .where(scenario_steps: {step_order: 0})
      .uploaded
      .order(created_at: :desc)
      .map(&:prezi)

  end

end

