DatatableFilters = function(config) {
  this.$fleetTable = config.fleetTable;
  this.$tablefleetTable = config.tablefleetTable;
  this.$filterContainer = config.filterContainer;
  this.$btnExportCsv = config.btnExportCsv;
  this.$ctnDisplayCountSelect = config.ctnDisplayCountSelect;
  this.$displayCountSelect = config.displayCountSelect;
  this.$inputCheckbox = config.inputCheckbox;
  this.$filtersSelect = config.filtersSelect;
  this.$btnSaveChanges = config.btnSaveChanges;

  this.$columnsSelected = Sortable.create(selected, { group: { name: 'columns', pull: true, put: true }, animation: 200 });
  this.$columnsAvailable = Sortable.create(available, { group: { name: 'columns', pull: true, put: true }, animation: 200 });

  this.$newFleetTemplate = Handlebars.compile(config.newFleetTemplate.html());

  this.init();
};

DatatableFilters.prototype.init = function() {
  this.$fleetTable.on('click', '.column-name', $.proxy(this.setSort, this));
  this.$btnExportCsv.on('click', $.proxy(this.exportToCsv, this));
  this.$displayCountSelect.on('click', $.proxy(this.setDisplayCount, this));
  this.$fleetTable.on('click', 'td', $.proxy(this.addToFilter, this));
  this.$inputCheckbox.on('change', $.proxy(this.addFilter, this));
  this.$filtersSelect.on('change', $.proxy(this.addFilter, this));
  this.$filterContainer.on('click', '.filter-item .close', $.proxy(this.removeFilter, this));
  this.$btnSaveChanges.on('click', $.proxy(this.updateList, this));
};

DatatableFilters.prototype.setSort = function(event) {
  var thisEl = $(event.currentTarget);
  var sorted = thisEl.attr('data-sorted') === "true";
  var direction = sorted && thisEl.attr('data-sorted-direction') === "asc" ? "desc" : "asc";
  var icon = thisEl.find('i');

  $('th[data-sorted=true]').attr('data-sorted', false)
  $('th[data-sorted-direction]').removeAttr('data-sorted-direction');
  thisEl.attr('data-sorted', true);
  thisEl.attr('data-sorted-direction', direction);

  this.updateList();
};

DatatableFilters.prototype.getSort = function() {
  var sort = $('th[data-sorted=true]').attr('data-type');
  var direction = $('th[data-sorted=true]').attr('data-sorted-direction');
  return { "sort_column": sort, "sort_direction": direction }
};

DatatableFilters.prototype.exportToCsv = function() {
  var displayCount = this.getDisplayCount();
  var sortParams = this.getSort();
  var datatableFilters = this.getFilters();
  var datatableColumns = this.getColumns();

  var href = new URI(window.location.href + "/export.csv")
    .addSearch("display_count", displayCount)
    .addSearch("sort_params[sort_column]", sortParams["sort_column"])
    .addSearch("sort_params[sort_direction]", sortParams["sort_direction"])
    .addSearch("datatable_columns[selected][]", datatableColumns["selected"])
    .addSearch("datatable_columns[available][]", datatableColumns["available"])

  $.each(datatableFilters, function(key, value) {
    href.addSearch("datatable_filters[" + key + '][]', value);
  });

  window.location.href = href;
};

DatatableFilters.prototype.setDisplayCount = function(event) {
  var thisEl = $(event.currentTarget);
  this.$ctnDisplayCountSelect.find('a[selected=selected]').removeAttr("selected");
  thisEl.attr("selected", true);

  this.updateList();
};


DatatableFilters.prototype.getDisplayCount = function(event) {
  return this.$ctnDisplayCountSelect.find('a[selected=selected]').text();
};

DatatableFilters.prototype.addFilter = function(event){
  var fieldMap = {
    "msn": "MSN",
    "aircraft_status": "Aircraft Status",
    "aircraft_manufacturer": "Manufacturer",
    "aircraft_model": "Aircraft Model",
    "aircraft_type": "Aircraft Type",
    "aircraft_series": "Aircraft Series",
    "registration": "Registration",
    "line_number": "Line Number",
    "engine_model": "Engine Model",
    "engine_variant": "Engine Variant",
    "operator": "Operator",
    "operator_country": "Operator Country",
    "operator_region": "Operator Region",
    "build_year": "Build Year",
    "aircraft_age": "Aircraft Age",
    "seats_configuration": "Seats Configuration",
    "last_delivery_date": "Last Delivery Date"
  };

  var fields = $("nav .selectpicker option:selected").add($('.filter :checked'));
  this.$filterContainer.html("");

  fields.each(function(index, element){
    var field = $(this).attr('name');
    var value = $(this).attr('value');
    var filterHeader = fieldMap[field];

    $('.filter-container').append(
      '<a class="filter-item" name="' + field + '"value="' + value + '">'
        + '<span class="close">&times;</span>'
        + filterHeader + ": " + '<span class="strong">' + value + '</span></a>'
    )
  });

  this.updateList();
};

DatatableFilters.prototype.addToFilter = function(event){
  var thisEl = $(event.currentTarget);
  var field = thisEl.attr('name');
  var value = thisEl.attr('value');

  if (field === "aircraft_status") {
    $('input[name="' + field + '"][value="' + value + '"]').prop("checked", true);
  } else {
    $('option[name="' + field + '"][value="' + value + '"]').prop("selected", true);
    this.$filtersSelect.selectpicker("refresh");
  }

  this.addFilter();
};

DatatableFilters.prototype.removeFilter = function(event){
  var thisEl = $(event.currentTarget);
  var filterItem = thisEl.closest('.filter-item');
  var field = filterItem.attr('name');
  var value = filterItem.attr('value');
  filterItem.remove();

  if (field === "aircraft_status") {
    $('input[name="' + field + '"][value="' + value + '"]').prop("checked", false);
  } else {
    $('option[name="' + field + '"][value="' + value + '"]').prop("selected", false);
    this.$filtersSelect.selectpicker("refresh");
  }

  this.updateList();
};

DatatableFilters.prototype.getFilters = function() {
  var filters = {};

  var selectedFilters = this.$filtersSelect.find("option:selected");
  selectedFilters.each(function(index, selectedFilter) {
    var field = $(selectedFilter).attr('name');
    var value = $(selectedFilter).attr('value');
    filters[field] ? filters[field].push(value) : filters[field] = [value];
  });

  var checkedboxes =  $('.filter :checked');
  checkedboxes.each(function(index, checkbox){
    var field = $(checkbox).attr('name');
    var value = $(checkbox).attr('value');
    filters[field] ? filters[field].push(value) : filters[field] = [value];
  });

  return filters;
};

DatatableFilters.prototype.getColumns = function() {
  var columnsSelected = this.$columnsSelected.toArray();
  var columnsAvailable = this.$columnsAvailable.toArray();
  return { "selected": columnsSelected, "available": columnsAvailable };
}

DatatableFilters.prototype.updateList = function() {
  var sortParams = this.getSort();
  var displayCount = this.getDisplayCount();
  var datatableFilters = this.getFilters();
  var datatableColumns = this.getColumns();
  var url = new URL(window.location.href).pathname;
  var newFleets = newFleets || { column_names: [], sort_column: '', sort_direction: '', fleets: [] };

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    data: {
      display_count: displayCount,
      sort_params: sortParams,
      datatable_filters: datatableFilters,
      datatable_columns: datatableColumns,
      authenticity_token: AUTH_TOKEN
    },
    success: function(response) {
      newFleets.column_names = response.column_names;
      newFleets.fleets = response.fleets;
      newFleets.sort_column = response.sort_column;
      newFleets.sort_direction = response.sort_direction;
      this.$tablefleetTable.html(this.$newFleetTemplate(newFleets));
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};
