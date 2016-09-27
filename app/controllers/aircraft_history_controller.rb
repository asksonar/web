require 'airsonar'

class AircraftHistoryController < ApplicationController
  before_action :authenticate_user!

  def create
    airsonar = Airsonar.new()

    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email

    update_params.each do |key, value|
      options[:aircraft_history][key] = value
    end

    airsonar.create_aircraft_history(
      params[:aircraft_history][:msn],
      params[:aircraft_history][:aircraft_model],
      options
    )

    flash[:info] = '<strong>Your suggestion has been submitted.</strong>'
    redirect_to aircraft_path(params[:aircraft_id])
  end

  def show
    @aircraft = Aircraft.find_by_hashid!(params[:aircraftHashId])
    @aircraft_history = AircraftHistory.find_by_hashid!(params[:aircraftHistoryHashId])

    render json: {
      aircraft: @aircraft,
      aircraft_history: @aircraft_history
    }
  end

  def update
    airsonar = Airsonar.new()

    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email

    update_params.each do |key, value|
      options[:aircraft_history][key] = value
    end

    airsonar.update_aircraft_history(
      params[:msn],
      params[:aircraft_model],
      params[:delivery_date],
      options
    )

    render json: { ok: true }
  end

  def destroy
    airsonar = Airsonar.new()

    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email

    airsonar.delete_aircraft_history(
      params[:msn],
      params[:aircraft_model],
      params[:delivery_date],
      options
    )

    render json: { ok: true }
  end

  private

  def update_params
    params.fetch(:aircraft_history, {}).permit(
      :delivery_date, :registration, :operator, :seats_configuration,
      :engine_model, :engine_variant, :aircraft_status
    )
  end
end
