class DraftsController < ApplicationController
  before_action :authenticate_user!

  def index
    @scenarios = scenarios_query.drafts(current_user.id).map(&:prezi)
  end

  def new
    @scenario = Scenario.new.prezi
    @template = Template.find_by(value: params[:template])
  end

  def edit
    @scenario = Scenario.find_by_hashid!(params[:id]).prezi
    @template = Template.find_by(value: params[:template])
    authorize @scenario
  end

  def create
    @scenario = drafts_service.create(
      scenario_params,
      scenario_steps_params,
      current_user,
      !params[:publish].nil?
    )

    if !@scenario.valid?
      render :new
      return
    end

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
  end

  def show
    redirect_to edit_draft_path
  end

  def update
    @scenario = Scenario.find_by_hashid!(params[:id])
    authorize @scenario

    drafts_service.update(
      @scenario,
      scenario_params,
      scenario_steps_params_with_hashid,
      current_user,
      !params[:publish].nil?
    )

    if !@scenario.valid?
      @scenario = @scenario.prezi
      render :edit
      return
    end

    if params[:publish]
      flash[:info] = '<strong>Study Published</strong> - ' \
        'Your study link is now ready to be shared with your users.'
      redirect_to result_path(@scenario)
    elsif params[:update]
      flash[:info] = '<strong>Study Updated</strong> - ' \
        'Your study link is now ready to be shared with your users.'
      redirect_to result_path(@scenario)
    else # if params[:draft]
      flash[:info] = "<strong>Draft Saved</strong> - #{@scenario.title}"
      redirect_to drafts_path
    end
  end

  def destroy
    @scenario = Scenario.find_by_hashid!(params[:id])
    authorize @scenario
    scenarios_service.set_deleted(@scenario)

    flash[:info] = '<strong>Your draft has been deleted.</strong>'
    render json: { redirect_url: drafts_path }
  end

  private

  def scenarios_service
    @scenarios_service ||= ScenariosService.instance
  end

  def scenarios_query
    @scenarios_query ||= ScenariosQuery.instance
  end

  def drafts_service
    @drafts_service ||= DraftsService.instance
  end

  def scenario_params
    params.require(:scenario).permit(:title, :description)
  end

  def scenario_steps_params
    scenario_steps_params_with_hashid.map { |params| params.permit(:description, :url, :step_order) }
  end

  def scenario_steps_params_with_hashid
    params.require(:scenario_steps).each_with_index.map do |step, index|
      return_val = ActionController::Parameters.new(step).permit(:description, :url, :hashid)
      return_val[:step_order] = index
      return_val
    end
  end
end
