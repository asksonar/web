class DraftsService
  include Singleton

  def create_draft(hash)
    Scenario.create(hash.merge({status: Scenario.statuses[:drafts]}))
  end

  def create_live(hash)
    Scenario.create(hash.merge({
      status: Scenario.statuses[:live],
      published_at: Time.new
    }))
  end

  def update_draft(scenario, hash)
    scenario.update(hash.merge({status: Scenario.statuses[:drafts]}))
  end

  def update_live(scenario, hash)
    scenario.update(hash.merge({
      status: Scenario.statuses[:live],
      published_at: Time.new
    }))
    scenario.track_draft_published()
  end

end
