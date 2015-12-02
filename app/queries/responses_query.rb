class ResponsesQuery
  include Singleton

  # beware sql injection with the column
  def distinct(column)
    Responder.pluck("DISTINCT #{column}")
  end

  def data(filter_hash = {})
    Response.joins(:responder).where(*where_clause(filter_hash))
  end

  def group_avg_rating(column, filter_hash = {})
    data(filter_hash).group(column).order(column.to_s).average(:rating)
  end

  def where_clause(filter_hash)
    where_keys = (filter_hash.map do |key, value|
      '(' + Array.new([*value].length).fill("#{key} = ?").join(' OR ') + ')'
    end).join(' AND ')
    where_values = filter_hash.values
    [where_keys, *where_values.flatten]
  end
end
