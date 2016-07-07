class FleetsPresenter
  attr_reader :display_count
  attr_reader :column_params
  attr_reader :sort_column
  attr_reader :sort_direction

  def initialize(company, display_count, sort_column, sort_direction, query_params: {}, column_params: column_params)
    @company = company
    @display_count = display_count
    @sort_column = sort_column
    @sort_direction = sort_direction
    @query_params = query_params
    @column_params = column_params
    @current_datatable_view = current_datatable_view
    @columns_selected ||= columns_selected
    @columns_available ||= columns_available
    @datatable_filters ||= datatable_filters
  end

  def saved_views
    datatable_views_service.get_saved_views(@company)
  end

  def current_datatable_view
    @company.datatable_views.where(current_view: true).first()
  end

  def columns_selected
    datatable_columns = datatable_views_service.get_datatable_columns(@current_datatable_view)
    datatable_columns['selected'] || []
  end

  def columns_available
    datatable_columns = datatable_views_service.get_datatable_columns(@current_datatable_view)
    datatable_columns['available'] || []
  end

  def datatable_filters
    datatable_views_service.get_datatable_filters(@current_datatable_view)
  end

  def datatable_filters_list
    datatable_filters_list = []

    @datatable_filters.each do |key, values|
      values.each do |value|
        datatable_filters_list.push({
          "field": key,
          "value": value
        })
      end
    end

    datatable_filters_list
  end

  def checked(field, value)
    [*(@datatable_filters[field])].include?(value)
  end

  def selected(field, value)
    [*(@datatable_filters[field])].include?(value)
  end

  def fleets
    return {} if @columns_selected.empty?
    query = fleets_query.fleets(filters: @query_params, columns: @columns_selected)
    query = query.order(@sort_column + " " + @sort_direction)
    query = query.first(@display_count) if @display_count != 'All'
    query
  end

  def fleets_json
    return {} if @column_params["selected"].nil?
    query = fleets_query.fleets(filters: @query_params, columns: @column_params["selected"])
    query = query.order(@sort_column + " " + @sort_direction)
    query = query.first(@display_count) if @display_count != 'All'
    # query = query.map { |fleet| { "hashid" => fleet.hashid }.merge(fleet.attributes) }
    query
  end

  def fleet
    @fleet ||= fleets_query.fleet(@query_params["id"])
  end

  def filters(field)
    fleets_query.filters(field)
  end

  private

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def datatable_views_service
    @datatable_views_service ||= DatatableViewsService.instance
  end
end
