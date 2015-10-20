class ScenariosService
  include Singleton

  def set_live(scenario)
    scenario.status = :live
    scenario.published_at = Time.new
    scenario.save
  end

  def set_completed(scenario)
    scenario.status = :completed
    scenario.completed_at = Time.new
    scenario.save
  end

  def set_deleted(scenario)
    scenario.status = :deleted
    scenario.save(validate: false)
  end

end
