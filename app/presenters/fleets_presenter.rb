class FleetsPresenter
  attr_reader :display_count
  attr_reader :column_params
  attr_reader :sort_column
  attr_reader :sort_direction

  def initialize(company, display_count, sort_column, sort_direction, query_params, column_params)
    @company = company
    @display_count = display_count
    @sort_column = sort_column
    @sort_direction = sort_direction
    @query_params = query_params
    @column_params = column_params
    @current_view = current_view
    @column_params_selected = column_params_selected
    @datatable_columns_selected = datatable_columns_selected
    @datatable_columns_available = datatable_columns_available
    @datatable_filters = datatable_filters
  end

  def saved_views
    datatable_views_service.get_saved_views(@company)
  end

  def current_view
    @company.datatable_views.where(current_view: true).first()
  end

  def column_params_selected
    @column_params["selected"] || []
  end

  def datatable_columns_selected
    datatable_columns = datatable_views_service.get_datatable_columns(@current_view)
    datatable_columns["selected"] || []
  end

  def datatable_columns_available
    datatable_columns = datatable_views_service.get_datatable_columns(@current_view)
    datatable_columns["available"] || []
  end

  def datatable_filters
    datatable_views_service.get_datatable_filters(@current_view)
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

  def fleet
    @fleet ||= fleets_query.fleet(@query_params["id"])
  end

  def fleets
    return {} if @datatable_columns_selected.empty?
    query = fleets_query.fleets(filters: @datatable_filters, columns: @datatable_columns_selected)
    query = query.order(@sort_column + " " + @sort_direction)
    query = query.first(@display_count) if @display_count != "All"
    query
  end

  def fleets_json
    return {} if @column_params_selected.empty?
    query = fleets_query.fleets(filters: @query_params, columns: @column_params_selected)
    query = query.order(@sort_column + " " + @sort_direction)
    query = query.first(@display_count) if @display_count != "All"
    # query = query.map { |fleet| { "hashid" => fleet.hashid }.merge(fleet.attributes) }
    query
  end

  def checked(field, value)
    [*(@datatable_filters[field])].include?(value)
  end

  def selected(field, value)
    [*(@datatable_filters[field])].include?(value)
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
