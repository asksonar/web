require 'airsonar'

class ResolutionsService
  include Singleton
  attr_reader :airsonar

  def initialize
    @airsonar = Airsonar.new()
  end

  def create_aircraft_history(msn, model, options)
    airsonar.create_aircraft_history(msn, model, options)
  end

  def update_aircraft(msn, model, options)
    airsonar.update_aircraft(msn, model, options)
  end

  def update_aircraft_history(msn, model, historyDate, options)
    airsonar.update_aircraft_history(msn, model, historyDate, options)
  end

  def delete_aircraft_history(msn, model, historyDate, options)
    airsonar.delete_aircraft_history(msn, model, historyDate, options)
  end
end
