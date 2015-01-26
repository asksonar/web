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
