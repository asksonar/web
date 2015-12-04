class ResponsesQuery
  include Singleton

  # strips out nil values
  def distinct(company_id, column)
    Responder.where(company_id: company_id).order(column).where.not(column => nil).distinct(column).pluck(column)
  end

  def responses(company_id, from: nil, to: nil, filter: {})
    query = data(*filter).where('company_id = ?', company_id)
    query = query.where('responses.created_at > ?', from) if from
    query = query.where('responses.created_at < ?', to) if to
    query.select(:rating, :text, :created_at, :region, :country, :responder_id, :nps)
  end

  def comments(*args, &block)
    responses(*args, &block).where.not(text: nil)
  end

  def nps_total_since(company_id, date, filter_hash = {})
    data(filter_hash)
      .where('company_id = ?', company_id)
      .where('responses.created_at > ?', date)
      .pluck('100.0 * sum(nps) / count(nps)')[0].round
  end

  def nps_split_since(company_id, date, filter_hash = {})
    data(filter_hash)
      .where('company_id = ?', company_id)
      .where('responses.created_at > ?', date)
      .group(:date_yyyymmdd)
      .group(:nps)
      .order(:date_yyyymmdd.to_s)
      .pluck('date_yyyymmdd, nps, count(1)')
      .each_with_object({}) do |item, object|
        date_yyyymmdd = item[0]
        nps = item[1]
        count = item[2]
        object[date_yyyymmdd] ||= {}
        object[date_yyyymmdd][nps] = count
      end
      .map { |key, value| { 'date_yyyymmdd' => key, '1' => 0, '0' => 0, '-1' => 0 }.merge(value) }
  end

  def nps_by_day_since(company_id, date, filter_hash = {})
    data(filter_hash)
      .where('company_id = ?', company_id)
      .where('responses.created_at > ?', date)
      .group(:date_yyyymmdd)
      .order(:date_yyyymmdd.to_s)
      .pluck("100.0 * sum(nps) / count(nps), date_yyyymmdd")
      .map { |val| { nps: val[0].round, date_yyyymmdd: val[1] } }
  end

  def nps_by_day(company_id, filter_hash = {})
    nps_by_category(company_id, :date_yyyymmdd, filter_hash)
  end

  def nps_by_category(company_id, column, filter_hash = {})
    data(filter_hash)
      .where('company_id = ?', company_id)
      .group(column)
      .order(column.to_s)
      .pluck("100.0 * sum(nps) / count(nps), #{column}")
      .map { |val| { nps: val[0].round, column => val[1] } }
  end

  private

  def data(filter_hash = {})
    Response.joins(:responder).where(*where_clause(filter_hash))
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
