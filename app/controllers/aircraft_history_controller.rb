require 'airsonar'

class AircraftHistoryController < ApplicationController
  before_action :authenticate_user!

  def create
    airsonar = Airsonar.new()

    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email
    options[:aircraft_history][:delivery_date] = "2016-09-19"
    options[:aircraft_history][:aircraft_status] = "Active"
    options[:aircraft_history][:aircraft_type] = "121"
    options[:aircraft_history][:engine_model] = "GE CF34-8E"
    options[:aircraft_history][:operator] = "EVA Airways"
    options[:aircraft_history][:registration] = "A-BCDE"

    airsonar.create_aircraft_history("27173", "747", options)
    flash[:info] = '<strong>Your suggestion has been submitted.</strong>'
    redirect_to fleet_path(params[:fleet_id])
  end

  def update
    airsonar = Airsonar.new()

    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email
    options[:aircraft_history][:operator] = "Delta Airlines"
    options[:aircraft_history][:aircraft_status] = "Scrapped"

    airsonar.update_aircraft_history("27173", "747", "2016-06-02", options)
    flash[:info] = '<strong>Your correction has been submitted.</strong>'
    redirect_to fleet_path(params[:fleet_id])
  end

  def destroy
    airsonar = Airsonar.new()

    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email

    airsonar.delete_aircraft_history("26561", "747", "2014-09-05", options)
    flash[:info] = '<strong>Your suggestion has been submitted.</strong>'
    redirect_to fleet_path(params[:fleet_id])
  end
end
