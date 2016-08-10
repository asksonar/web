class Aircraft < ActiveRecord::Base
  HASHIDS_SALT = 'dloYZQtiO2yy'

  def self.to_csv(all_fleets, attributes)
    attribute_names = attributes.map do |column|
      Aircraft.human_attribute_name(column)
    end

    CSV.generate(headers: true) do |csv|
      csv << attribute_names
      all_fleets.each do |fleet|
        csv << fleet.values_at(*attributes)
      end
    end
  end
end
