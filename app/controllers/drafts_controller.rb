class DraftsController < ApplicationController
  before_action :authenticate_researcher!

  attr_writer :scenarios_service
  attr_writer :drafts_service

  def scenarios_service
    @scenarios_service ||= ScenariosService.instance
  end

  def drafts_service
    @drafts_service ||= DraftsService.instance
  end

  def index
    @scenarios = scenarios_service.drafts(current_researcher.id)
  end

  def new
    @scenario = Scenario.new.prezi
    @template = Template.find_by(value: params[:template])
  end

  def edit
    @scenario = Scenario.find_by_hashid(params[:id]).prezi
    @template = Template.find_by(value: params[:template])
  end

  def create
    @scenario = drafts_service.create(
      scenario_params,
      scenario_steps_params,
      current_researcher,
      !params[:publish].nil?
    )

    if params[:publish]
      flash[:info] = '<strong>Study Published</strong> - ' \
        'Your study link is now ready to be shared with your users.'
      redirect_to result_path(@scenario)
    else
      flash[:info] = "<strong>Draft Saved</strong> - #{@scenario.title}"
      redirect_to drafts_path
    end

    if params[:scenario][:template] == 'sample'
      response.location += '?walkthrough=share'
    end

    # if we published
    #   redirect to individual results page
    #   flash that we are now able to share with customers
    # if we just save the draft
    #   redirect to draft list
    #   flash that list
  end

  def show
    redirect_to edit_draft_path
  end

  def update
    @scenario = Scenario.find_by_hashid(params[:id])

    drafts_service.update(
      @scenario,
      scenario_params,
      scenario_steps_params,
      current_researcher,
      !params[:publish].nil?
    )

    if params[:publish]
      flash[:info] = '<strong>Study Published</strong> - ' \
        'Your study link is now ready to be shared with your users.'
      redirect_to result_path(@scenario)
    elsif params[:draft]
      flash[:info] = "<strong>Draft Saved</strong> - #{@scenario.title}"
      redirect_to drafts_path
    elsif params[:update]
      flash[:info] = '<strong>Study Updated</strong> - ' \
        'Your study link is now ready to be shared with your users.'
      redirect_to result_path(@scenario)
    end

    # need to update in place
    # then the resulting pathing is the same as create pretty much
  end

  private

  def scenario_params
    params.require(:scenario).permit(:title, :description)
  end

  def scenario_steps_params
    params.require(:scenario_steps).each_with_index.map do |step, index|
      return_val = ActionController::Parameters.new(step).permit(:description, :url, :hashid)
      return_val[:step_order] = index
      return_val
    end
  end

end
