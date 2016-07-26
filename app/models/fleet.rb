class Fleet < ActiveRecord::Base
  HASHIDS_SALT = 'dloYZQtiO2yy'

  def self.to_csv(all_fleets, attributes)
    attribute_names = attributes.map do |column|
      Fleet.human_attribute_name(column)
    end

    CSV.generate(headers: true) do |csv|
      csv << attribute_names
      all_fleets.each do |fleet|
        csv << fleet.attributes.values_at(*attributes)
      end
    end
  end
end
