class Fleet < ActiveRecord::Base
  HASHIDS_SALT = 'dloYZQtiO2yy'

  def self.to_csv(all_fleets)
    attributes = %w{msn aircraft_status aircraft_model build_year airline}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all_fleets.each do |fleet|
        csv << fleet.attributes.values_at(*attributes)
      end
    end
  end
end
