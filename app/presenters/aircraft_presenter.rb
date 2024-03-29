class AircraftPresenter
  attr_reader :display_count
  attr_reader :column_params
  attr_reader :sort_column
  attr_reader :sort_direction

  def initialize(id, company, display_count, sort_column, sort_direction, query_params, column_params)
    @id = id
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
    @company.datatable_views.where.not(default_view: true)
  end

  def current_view
    @company.datatable_views.where(current_view: true).first()
  end

  def column_params_selected
    @column_params["selected"] || []
  end

  def datatable_columns_selected
    datatable_columns = JSON.parse(@current_view.datatable_columns)
    datatable_columns["selected"] || []
  end

  def datatable_columns_available
    datatable_columns = JSON.parse(@current_view.datatable_columns)
    datatable_columns["available"] || []
  end

  def datatable_filters
    JSON.parse(@current_view.datatable_filters)
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

  def aircraft
    @aircraft ||= aircraft_query.aircraft(@id)
  end

  def aircraft_histories
    @aircraft_histories ||= aircraft_histories_query.aircraft_histories(@id)
  end

  def aircraft_fleet
    return {} if @datatable_columns_selected.empty?
    query = aircraft_query.aircraft_fleet(filters: @datatable_filters, columns: @datatable_columns_selected)
    query = query.order(@sort_column + " " + @sort_direction)
    query = query.first(@display_count) if @display_count != "All"
    query = query.map { |aircraft| { "hashid" => aircraft.hashid }.merge(aircraft.attributes) }
    query
  end

  def aircraft_fleet_json
    return {} if @column_params_selected.empty?
    query = aircraft_query.aircraft_fleet(filters: @query_params, columns: @column_params_selected)
    query = query.order(@sort_column + " " + @sort_direction)
    query = query.first(@display_count) if @display_count != "All"
    query = query.map { |aircraft| { "hashid" => aircraft.hashid }.merge(aircraft.attributes) }
    query
  end

  def checked(field, value)
    [*(@datatable_filters[field])].include?(value)
  end

  def selected(field, value)
    [*(@datatable_filters[field])].include?(value)
  end

  def filters(field)
    aircraft_query.filters(field)
  end

  private

  def aircraft_query
    @aircraft_query ||= AircraftQuery.instance
  end

  def aircraft_histories_query
    @aircraft_histories_query ||= AircraftHistoriesQuery.instance
  end

  def datatable_views_service
    @datatable_views_service ||= DatatableViewsService.instance
  end
end
