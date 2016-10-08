class AircraftHistoryController < ApplicationController
  before_action :authenticate_user!

  def create
    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email
    options[:user_comment] = aircraft_history_params[:user_comment]

    update_params.each do |key, value|
      options[:aircraft_history][key] = value
    end

    api.create_aircraft_history(aircraft_history_params[:msn], aircraft_history_params[:aircraft_model], options)
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
    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email
    options[:user_comment] = user_comment
    
    update_params.each do |key, value|
      options[:aircraft_history][key] = value
    end

    api.update_aircraft_history(params[:msn], params[:aircraft_model], delivery_date, options)
    render json: { ok: true }
  end

  def destroy
    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email
    options[:user_comment] = user_comment

    api.delete_aircraft_history(params[:msn], params[:aircraft_model], delivery_date, options)
    render json: { ok: true }
  end

  private

  def user_comment
    aircraft_history_params.present? && aircraft_history_params[:user_comment].presence || ''
  end

  def delivery_date
    params[:delivery_date] || ''
  end

  def aircraft_history_params
    params[:aircraft_history]
  end

  def update_params
    params.fetch(:aircraft_history, {}).permit(
      :delivery_date, :registration, :operator_name, :seats_configuration, :engine_name, :aircraft_status
    )
  end

  def api
    @api ||= ResolutionsService.instance
  end
end
