class Aircraft < ActiveRecord::Base
  HASHIDS_SALT = 'dloYZQtiO2yy'

  def self.to_csv(aircraft_fleet, attributes)
    attribute_names = attributes.map do |column|
      Aircraft.human_attribute_name(column)
    end

    CSV.generate(headers: true) do |csv|
      csv << attribute_names
      aircraft_fleet.each do |aircraft|
        csv << aircraft.values_at(*attributes)
      end
    end
  end
end
