class ScenariosController < ApplicationController
  include EmailUtils

	def index
    hash = {}
    hash[:company] = current_user.company
    if @status = params[:status] then hash[:status] = Scenario.statuses[@status] end
    if @owner = params[:owner]
      if @owner == 'me'
        hash[:created_by] = current_user.id
      else
        hash[:created_by] = params[:owner]
      end
    end

		@scenarios = Scenario.where(hash)
	end

  def my_index
    params[:owner] = 'me'
    index
    render :index
  end

	def create
		#render plain: params[:scenario].inspect
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

		redirect_to @scenario
	end

	def show
		@scenario = Scenario.find(params[:id])
	end

  def destroy
    @scenario = Scenario.find(params[:id])
    @scenario.destroy
    flash[:scenario_message] = %q|Deleted scenario "| + @scenario.title + %q|"|
    redirect_to scenarios_path
  end

	private
		def scenario_params
			params.require(:scenario).permit(:title, :description)
		end
end
