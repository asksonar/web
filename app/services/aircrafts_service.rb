class AircraftsService
  include Singleton

  def create(aircraft_params, user)
    # save all the changes
    ActiveRecord::Base.transaction do
      aircraft = Aircraft.new(aircraft_params)
      aircraft.company = user.company

      if aircraft.valid?
        aircraft.save
      end

      aircraft
    end
  end

  def update(aircraft, aircraft_params, user)
    ActiveRecord::Base.transaction do
      aircraft.assign_attributes(aircraft_params)

      if aircraft.valid?
        aircraft.save
      end

      aircraft
    end
  end
end
