class ScenariosController < ApplicationController
	def index
		@scenarios = Scenario.all
	end

	def create
		#render plain: params[:scenario].inspect
		@scenario = Scenario.new(scenario_params)
		@scenario.save

		params['steps'].each do |stepDescription|
			debugger

			scenarioStep = ScenarioStep.new(description: stepDescription, scenario:@scenario)
			scenarioStep.save
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
