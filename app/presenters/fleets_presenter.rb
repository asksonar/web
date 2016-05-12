class FleetsPresenter
  attr_reader :display_count

  def initialize(display_count:)
    @display_count = display_count.to_i
  end

  def fleets
    @fleets ||= Fleet.first(@display_count)
  end
end
