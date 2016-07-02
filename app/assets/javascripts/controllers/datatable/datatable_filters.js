DatatableFilters = function(config) {
  this.$fleetTable = config.fleetTable;
  this.$fleetTableBody = config.fleetTableBody;
  this.$filterContainer = config.filterContainer;
  this.$btnExportCsv = config.btnExportCsv;
  this.$ctnDisplayCountSelect = config.ctnDisplayCountSelect;
  this.$displayCountSelect = config.displayCountSelect;
  this.$inputCheckbox = config.inputCheckbox;
  this.$filtersSelect = config.filtersSelect;

  this.$newFleetTemplate = Handlebars.compile(config.newFleetTemplate.html());

  this.init();
};

DatatableFilters.prototype.init = function() {
  this.$fleetTable.on('click', '.column-name', $.proxy(this.setSort, this));
  this.$filterContainer.on('click', '.filter-item', $.proxy(this.removeFilter, this));
  this.$btnExportCsv.on('click', $.proxy(this.exportToCsv, this));
  this.$displayCountSelect.on('click', $.proxy(this.setDisplayCount, this));
  this.$fleetTable.on('click', 'td', $.proxy(this.addToFilter, this));
  this.$inputCheckbox.on('change', $.proxy(this.addFilter, this));
  this.$filtersSelect.on('change', $.proxy(this.addFilter, this));
};

DatatableFilters.prototype.addFilter = function(event){
  var fieldMap = {
    "aircraft_status": "Aircraft Status",
    "aircraft_manufacturer": "Aircraft Manufacturer",
    "aircraft_type": "Aircraft Type",
    "aircraft_series": "Aircraft Series",
    "engine_type": "Engine Type",
    "engine_variant": "Engine Variant",
    "manager": "Manager",
    "operator": "Operator",
    "owner": "Owner",
    "operator_country": "Operator Country"
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
  var field = thisEl.attr('name');
  var value = thisEl.attr('value');
  thisEl.remove();

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

DatatableFilters.prototype.setDisplayCount = function(event) {
  var thisEl = $(event.currentTarget);
  this.$ctnDisplayCountSelect.find('a[selected=selected]').removeAttr("selected");
  thisEl.attr("selected", true);

  this.updateList();
};


DatatableFilters.prototype.getDisplayCount = function(event) {
  return { "display_count": this.$ctnDisplayCountSelect.find('a[selected=selected]').text() };
};

DatatableFilters.prototype.updateList = function() {
  var filters = this.getFilters();
  var displayCount = this.getDisplayCount();
  var sort = this.getSort();
  var url = new URL(window.location.href).pathname;
  var newFleets = newFleets || { column_names: [], fleets: [] };

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    data: $.extend(filters, displayCount, sort, {
      authenticity_token: AUTH_TOKEN
    }),
    success: function(response) {
      $('.fleet-line').remove();
      newFleets.column_names = response.column_names;
      newFleets.fleets = response.fleets;
      this.$fleetTableBody.append(this.$newFleetTemplate(newFleets));
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

DatatableFilters.prototype.setSort = function(event) {
  var thisEl = $(event.currentTarget);
  var sorted = thisEl.attr('data-sorted') === "true";
  var direction = sorted && thisEl.attr('data-sorted-direction') === "asc" ? "desc" : "asc";
  var icon = thisEl.find('i');

  if ( icon.hasClass('fa-caret-down') ) {
    icon.removeClass("fa-caret-down").addClass("fa-caret-up");
  } else {
    icon.removeClass("fa-caret-up").addClass("fa-caret-down");
  }

  $('th[data-sorted=true]').attr('data-sorted', false)
  $('th[data-sorted-direction]').removeAttr('data-sorted-direction');
  thisEl.attr('data-sorted', true);
  thisEl.attr('data-sorted-direction', direction);

  this.updateList();
};

DatatableFilters.prototype.getSort = function() {
  var sort = $('th[data-sorted=true]').attr('data-type');
  var direction = $('th[data-sorted=true]').attr('data-sorted-direction');
  return { "sort": sort, "direction": direction }
};

DatatableFilters.prototype.exportToCsv = function() {
  var filters = this.getFilters();
  var displayCount = this.getDisplayCount();
  var sort = this.getSort();
  window.location.href = new URI(window.location.href + "/export.csv").addSearch(filters).addSearch(displayCount).addSearch(sort);
};
