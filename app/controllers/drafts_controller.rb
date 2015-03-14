class DraftsController < ApplicationController

  def index
    @scenarios = Scenario.drafts
  end

  def new
    @product_templates = Template.product_templates
    @marketing_templates = Template.marketing_templates
    @template = Template.find_by(value: params[:template])
  end

  def create
    # save all the changes
    ActiveRecord::Base.transaction do
      @scenario = Scenario.create(scenario_params, current_user.researcher)

      emails = parse_emails(params[:scenario][:emails])
      users = User.bulk_create(emails)

      UserScenario.bulk_create(users, @scenario)

      params[:steps].each_with_index do |step_description, index|
        ScenarioStep.create(description: step_description, scenario: @scenario, step_order: index)
        #??? scenarioStep = @scenario.scenarioSteps.create(description: stepDescription)
      end
    end

    # if we published
    #   redirect to individual results page
    #   flash that we are now able to share with customers
    # if we just save the draft
    #   redirect to draft list
    #   flash that list
  end

  def edit
    @scenario = Scenario.find(params[:id])
    new
    render :new
    # need to modify the new page to indicate it is editing
  end

  def update
    @scenario = Scenario.find(params[:id])
    # need to update in place
    # then the resulting pathing is the same as create pretty much
  end

  def destroy
    # should just redirect to the All Results page if there is no id
    # if there is an id, then it should go back to the drafts list and show deleted
  end

end
