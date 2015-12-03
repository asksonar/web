class ResponsesQuery
  include Singleton

  # strips out nil values
  def distinct(column)
    Responder.order(column).where.not(column => nil).distinct(column).pluck(column)
  end

  def data(filter_hash = {})
    Response.joins(:responder).where(*where_clause(filter_hash))
  end

  def responses(filter_hash = {})
    data(filter_hash).select(:rating, :text, :created_at, :region, :country, :responder_id)
  end

  def nps_by_day(filter_hash = {})
    nps_by_category(:date_yyyymmdd, filter_hash)
  end

  def nps_by_category(column, filter_hash = {})
    data(filter_hash)
      .group(column)
      .order(column.to_s)
      .pluck("100.0 * sum(nps) / count(nps), #{column}")
      .map { |val| { nps: val[0].round(1), column => val[1] } }
  end

  def where_clause(filter_hash)
    where_keys = (filter_hash.map do |key, value|
      or_length = value.nil? ? 1 : [*value].length
      '(' + Array.new(or_length).fill("#{key} = ?").join(' OR ') + ')'
    end).join(' AND ')
    where_values = filter_hash.values
    [where_keys, *where_values.flatten]
  end
end
