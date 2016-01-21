class PingController < ApplicationController
  skip_after_action :track_page_viewed

  def index
    headers['Last-Modified'] = Time.now.httpdate
    database_connected = ActiveRecord::Base.connected?
    details = {
      database_connected: database_connected,
      status: (database_connected ? 200 : 500)
    }
    render status: status, json: details
  end
end
