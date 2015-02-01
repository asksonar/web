class ScenariosController < ApplicationController
	def new
	end

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

	private
		def scenario_params
			params.require(:scenario).permit(:title, :description)
		end
end
