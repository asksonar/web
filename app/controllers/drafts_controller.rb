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
    p 'calling new'
    new_or_edit(Scenario.new({
      scenario_steps: [ScenarioStep.new()],
      status: :drafts
    }))
    render :new
  end

  def edit
    p 'calling edit'
    new_or_edit(Scenario.find_by_hashid(params[:id]))
    render :new
    # TODO: modify the new page to indicate it is editing
  end

  def new_or_edit(scenario)
    p scenario
    @scenario = scenario
    @product_templates = Template.product_templates
    @marketing_templates = Template.marketing_templates
    if @template = Template.find_by(value: params[:template])
      @scenario = @template.to_scenario(@scenario)
    end
  end

  def create
    # save all the changes
    ActiveRecord::Base.transaction do

      if params[:draft]
        create_action = Proc.new { |x| drafts_service.create_draft(x) }
        p 'create_draft'
      elsif params[:publish]
        create_action = Proc.new { |x| drafts_service.create_live(x) }
        p 'create_live'
      else
        raise "Illegal commit value of " + params[:commit]
      end

      @scenario = create_action.call(scenario_params.merge({
        created_by: current_researcher,
        company: current_researcher.company,
      }))

      @scenario.scenario_steps.create(scenario_steps_params)
    end

    if params[:publish]
      flash[:info] = "<strong>Study Published</strong> - Your study link is now ready to be shared with your users."
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
    ActiveRecord::Base.transaction do
      if params[:draft]
        drafts_service.update_draft(@scenario, scenario_params)
      elsif params[:publish]
        drafts_service.update_live(@scenario, scenario_params)
      elsif params[:update]
        @scenario.update(scenario_params)
      else
        raise "Illegal commit value of " + params[:commit]
      end

      if params[:update]
        # only update the text of them in order
        scenario_steps_params.each do |new_step|
          old_step = @scenario.scenario_steps.find_by(step_order: new_step[:step_order])
          old_step.description = new_step[:description]
          old_step.url = new_step[:url]
          old_step.save()
        end

      else
        @scenario.scenario_steps.each do |step|
          step.destroy
        end

        @scenario.scenario_steps.create(scenario_steps_params)
      end

    end

    if params[:publish]
      flash[:info] = "<strong>Study Published</strong> - Your study link is now ready to be shared with your users."
      redirect_to result_path(@scenario)
    elsif params[:draft]
      flash[:info] = "<strong>Draft Saved</strong> - #{@scenario.title}"
      redirect_to drafts_path
    elsif params[:update]
      flash[:info] = "<strong>Study Updated</strong> - Your study link is now ready to be shared with your users."
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
        return_val = ActionController::Parameters.new(step).permit(:description, :url)
        return_val[:step_order] = index
        return_val
      end
    end

end
