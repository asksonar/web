class AircraftPresenter < SimpleDelegator
  # needed for bootstrap_form_for
  def self.validators_on(*attributes)
    Aircraft.validators_on(*attributes)
  end
end
