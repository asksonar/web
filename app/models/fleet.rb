class Fleet < ActiveRecord::Base
  HASHIDS_SALT = 'dloYZQtiO2yy'

  def self.to_csv(all_fleets)
    attributes = %w{serial_number aircraft_status aircraft_type build_year operator}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all_fleets.each do |fleet|
        csv << fleet.attributes.values_at(*attributes)
      end
    end
  end
end
