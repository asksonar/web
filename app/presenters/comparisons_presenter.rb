class ComparisonsPresenter
  def initialize(comparison_field, filter_hash)
    @comparison_field = comparison_field
    @filter_hash = filter_hash
  end

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end

  # def regions
  #   responses_query.distinct(:region)
  # end

  def countries
    responses_query.distinct(:country)
  end

  def data_json
    responses_query.data(@filter_hash).select(:rating, :text, :created_at, :region, :country, :responder_id).to_json
  end

  def group_avg_rating_json
    responses_query.group_avg_rating(@comparison_field, @filter_hash).map do |key, value|
      {
        @comparison_field => key,
        rating: value
      }
    end.to_json
  end

  def checked(field, value)
    [*(@filter_hash[field])].include?(value)
  end
end
