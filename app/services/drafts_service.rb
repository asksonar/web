class DraftsService
  include Singleton

  def self.create_draft(hash)
    Scenario.create(hash.merge({status: statuses[:drafts]}))
  end

  def self.create_live(hash)
    Scenario.create(hash.merge({
      status: statuses[:live],
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
