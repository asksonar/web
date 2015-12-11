class ResponsesQuery
  include Singleton

  # strips out nil values
  def distinct(company_id, column)
    Responder.where(company_id: company_id).order(column).where.not(column => nil).distinct(column).pluck(column)
  end

  def responses(company_id, from: nil, to: nil, filter: {})
    data(company_id, from, to, filter)
      .select(:rating, :text, :created_at, :region, :country, :responder_id, :nps)
  end

  def comments(company_id, from: nil, to: nil, filter: {})
    responses(company_id, from: from, to: to, filter: filter).where.not(text: nil)
  end

  def nps_total(company_id, from: nil, to: nil, filter: {})
    data(company_id, from, to, filter)
      .pluck('100.0 * sum(nps) / count(nps)')[0].try(:round)
  end

  def nps_by_day(company_id, from: nil, to: nil, filter: {})
    nps_by_category(company_id, :date_yyyymmdd, from: from, to: to, filter: filter)
  end

  def nps_by_category(company_id, column, from: nil, to: nil, filter: {})
    data(company_id, from, to, filter)
      .group(column)
      .group(:nps)
      .order(column.to_s)
      .pluck("#{column}, nps, count(1)")
      .each_with_object({}) do |item, object|
        column_val = item[0]
        nps = item[1]
        count = item[2]
        object[column_val] = (object[column_val] || { 1 => 0, 0 => 0, -1 => 0 }).merge(nps => count)
      end
      .map do |key, object|
        { column =>  key,
          nps: (
            100.0 *
            (object[1] - object[-1]) /
            (object[1] + object[0] + object[-1])
          ).round
        }.merge(object)
      end
  end

  private

  def data(company_id, from, to, filter)
    query = Response.joins(:responder).where('company_id = ?', company_id).where.not(nps: nil)
    query = query.where(*where_clause(filter)) if !filter.nil?
    query = query.where('responses.created_at > ?', from) if from
    query = query.where('responses.created_at < ?', to) if to
    query
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
