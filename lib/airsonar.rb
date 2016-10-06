class Airsonar
  include HTTParty
  base_uri 'webservices-env.m4edbzxi9e.us-west-2.elasticbeanstalk.com'
  raise_on (400..599).to_a

  def initialize()
    @options = {
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => Rails.application.secrets.airsonar_api_key
      }
    }
  end

  def create_aircraft_history(msn, model, options)
    options = @options.merge({ body: options.to_json })
    self.class.post("/aircraftDataSvc/aircraft/msn/#{msn}/model/#{model}/historyItem", options)
  end

  def update_aircraft(msn, model, options)
    options = @options.merge({ body: options.to_json })
    self.class.patch("/aircraftDataSvc/aircraft/msn/#{msn}/model/#{model}", options)
  end

  def update_aircraft_history(msn, model, historyDate, options)
    options = @options.merge({ body: options.to_json })
    self.class.patch("/aircraftDataSvc/aircraft/msn/#{msn}/model/#{model}/historyDate/#{historyDate}", options)
  end

  def delete_aircraft_history(msn, model, historyDate, options)
    options = @options.merge({ body: options.to_json })
    self.class.delete("/aircraftDataSvc/aircraft/msn/#{msn}/model/#{model}/historyDate/#{historyDate}", options)
  end
end
