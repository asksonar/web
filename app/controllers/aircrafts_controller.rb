class AircraftsController < ApplicationController
  before_action :authenticate_user!

  def index
    @aircrafts = Aircraft.where(company: current_user.company).map(&:prezi)
  end

  def show
    @aircraft = Aircraft.find_by_hashid!(params[:id]).prezi
  end

  def new
    @aircraft = Aircraft.new.prezi
  end

  def edit
    @aircraft = Aircraft.find_by_hashid!(params[:id]).prezi
  end

  def create
    @aircraft = aircrafts_service.create(
      aircraft_params,
      current_user
    )

    if !@aircraft.valid?
      render :new
      return
    end

    redirect_to aircrafts_path
  end

  def update
    @aircraft = Aircraft.find_by_hashid!(params[:id])

    aircrafts_service.update(
      @aircraft,
      aircraft_params,
      current_user,
    )

    if !@aircraft.valid?
      render :edit
      return
    end

    redirect_to aircraft_path(@aircraft)
  end

  private

  def aircrafts_service
    @aircrafts_service ||= AircraftsService.instance
  end

  def aircraft_params
    params
      .require(:aircraft)
      .permit(:msn, :aircraft_type, :aircraft_model, :asset_owner, :asset_manager, :registration, :manufacturer, :manufacture_date, :flight_hours, :flight_cycles)
  end
end
