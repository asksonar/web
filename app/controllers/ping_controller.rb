class PingController < ApplicationController
  def index

    details = {}
    database_connected = ActiveRecord::Base.connected?
    details['database_connected'] = database_connected

    if database_connected
      status = 200
    else
      status = 500
    end

    details['status'] = status

    headers['Last-Modified'] = Time.now.httpdate
    render status: status, json: details
  end

end
