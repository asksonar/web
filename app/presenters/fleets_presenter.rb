class FleetsPresenter
  attr_reader :display_count

  def initialize(company, display_count, sort_column, sort_direction, query_params: {}, column_params: {})
    @company = company
    @display_count = display_count
    @sort_column = sort_column
    @sort_direction = sort_direction
    @query_params = query_params
    @column_params = column_params
    @columns_selected ||= columns_selected
    @columns_available ||= columns_available
  end

  def columns_selected
    @datatable_view = @company.datatable_views.find_by(default_view: true)
    datatable_columns = fleets_service.get_datatable_columns(@datatable_view)
    datatable_columns['selected'] || []
  end

  def columns_available
    @datatable_view = @company.datatable_views.find_by(default_view: true)
    datatable_columns = fleets_service.get_datatable_columns(@datatable_view)
    datatable_columns['available'] || []
  end

  def update_datatable_columns
    @datatable_view = @company.datatable_views.find_by(default_view: true)
    fleets_service.update_datatable_columns(@datatable_view, @column_params)
  end

  def fleets
    if @columns_selected.empty?
      {}
    else
      query = fleets_query.fleets(filters: @query_params, columns: @columns_selected)
      query = query.order(@sort_column + " " + @sort_direction)
      query = query.first(@display_count) if @display_count != 'All'
      query
    end
  end

  def fleets_json
    if @columns_selected.empty?
      {}
    else
      query = fleets_query.fleets(filters: @query_params, columns: @columns_selected)
      query = query.order(@sort_column + " " + @sort_direction)
      query = query.first(@display_count) if @display_count != 'All'
      query = query.map { |fleet| { "hashid" => fleet.hashid }.merge(fleet.attributes) }
      query
    end
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

  def fleets_service
    @fleets_service ||= FleetsService.instance
  end
end
