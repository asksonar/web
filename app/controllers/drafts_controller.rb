class DraftsController < ApplicationController
  before_action :authenticate_researcher!

  EMPTY_SCENARIO = Scenario.new({
    scenario_steps: [ScenarioStep.new()]
  })

  def index
    @scenarios = Scenario.drafts(current_researcher.id)
  end

  def new(scenario = EMPTY_SCENARIO)
    @scenario = scenario
    @product_templates = Template.product_templates
    @marketing_templates = Template.marketing_templates
    if @template = Template.find_by(value: params[:template])
      @scenario = @template.to_scenario(@scenario) #to_param)
    end
  end

  def create
    # save all the changes
    ActiveRecord::Base.transaction do

      if params[:draft]
        create_action = Proc.new { |x| Scenario.create_draft(x) }
      elsif params[:publish]
        create_action = Proc.new { |x| Scenario.create_live(x) }
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
      flash[:info] = "<strong>Scenario Published</strong> - Your scenario is now ready to be shared with your users"
      redirect_to result_path(@scenario)
    else
      flash[:info] = "<strong>Draft Saved</strong> - #{@scenario.title}"
      redirect_to drafts_path
    end

    # if we published
    #   redirect to individual results page
    #   flash that we are now able to share with customers
    # if we just save the draft
    #   redirect to draft list
    #   flash that list
  end

  def edit
    new(Scenario.find_by_hashid(params[:id]))
    render :new
    # need to modify the new page to indicate it is editing
  end

  def update
    @scenario = Scenario.find_by_hashid(params[:id])
    ActiveRecord::Base.transaction do
      if params[:draft]
        @scenario.update_draft(scenario_params)
      elsif params[:publish]
        @scenario.update_live(scenario_params.merge({
          published_at: Time.new
        }))
      else
        raise "Illegal commit value of " + params[:commit]
      end

      scenario_steps_params_map = {}
      scenario_steps_params.each { |p| scenario_steps_params_map[p[:id]] = p }
      scenario_steps_params_map.each do |id, step|
        if update_me = ScenarioStep.find_by_hashid(id)
          update_me.update(step)
        else
          @scenario.scenario_steps.create(step)
        end
      end

      @scenario.scenario_steps.each do |step|
        if not scenario_steps_params_map.keys.include? step.id.to_s
          step.destroy
        end
      end
    end

    if params[:publish]
      flash[:info] = "<strong>Scenario Published</strong> - Your scenario is now ready to be shared with your users"
      redirect_to result_path(@scenario)
    else
      flash[:info] = "<strong>Draft Saved</strong> - #{@scenario.title}"
      redirect_to drafts_path
    end

    # need to update in place
    # then the resulting pathing is the same as create pretty much
  end

  def destroy
    # should just redirect to the All Results page if there is no id
    # if there is an id, then it should go back to the drafts list and show deleted
  end

  private
    def scenario_params
      params.require(:scenario).permit(:title, :description)
    end

    def scenario_steps_params
      params.require(:scenario_steps).each_with_index.map do |step, index|
        return_val = ActionController::Parameters.new(step).permit(:id, :description, :url)
        return_val[:step_order] = index
        return_val
      end
    end

end
