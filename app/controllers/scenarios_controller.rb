class ScenariosController < ApplicationController
  include EmailUtils

	def index
		@scenarios = Scenario.all
	end

	def create
		#render plain: params[:scenario].inspect
    ActiveRecord::Base.transaction do
      debugger

  		@scenario = Scenario.create(scenario_params)

      emails = parse_emails(params[:scenario][:emails])
      users = User.bulk_create(emails)

      UserScenario.bulk_create(users, @scenario)

  		params[:steps].each do |stepDescription|
  			ScenarioStep.create(description: stepDescription, scenario:@scenario)
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
