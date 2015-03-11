class ScenariosController < ApplicationController
  include EmailUtils

	def index
    @status = params[:status] || 'published'
		@scenarios = Scenario.where(company: current_user.company, status: Scenario.statuses[@status])
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
