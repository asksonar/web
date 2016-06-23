DatabaseFilters = function(config) {
  this.$fleetTable = config.fleetTable;
  this.$fleetTableBody = config.fleetTableBody;
  this.$filterContainer = config.filterContainer;
  this.$btnExportCsv = config.btnExportCsv;
  this.$resultCount = config.resultCount;
  this.$displayCountSelect = config.displayCountSelect;
  this.$inputCheckbox = config.inputCheckbox;
  this.$filtersSelect = config.filtersSelect;

  this.$newFleetTemplate = Handlebars.compile(config.newFleetTemplate.html());

  this.init();
};

DatabaseFilters.prototype.init = function() {
  this.$fleetTable.on('click', 'th', $.proxy(this.setSort, this));
  this.$filterContainer.on('click', '.filter-item', $.proxy(this.removeFilter, this));
  this.$btnExportCsv.on('click', $.proxy(this.exportToCsv, this));
  this.$displayCountSelect.on('change', $.proxy(this.updateList, this));
  this.$fleetTable.on('click', 'td', $.proxy(this.addToFilter, this));
  this.$inputCheckbox.on('change', $.proxy(this.addFilter, this));
  this.$filtersSelect.on('change', $.proxy(this.addFilter, this));
};

DatabaseFilters.prototype.addFilter = function(event){
  var fieldMap = {
    "aircraft_status": "Aircraft Status",
    "aircraft_manufacturer": "Manufacturer",
    "aircraft_type": "Aircraft Type",
    "aircraft_series": "Aircraft Series",
    "engine_type": "Engine Type",
    "engine_variant": "Engine Variant",
    "manager": "Lessor",
    "operator": "Operator",
    "owner": "Owner",
    "operator_country": "Country"
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

DatabaseFilters.prototype.addToFilter = function(event){
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

DatabaseFilters.prototype.removeFilter = function(event){
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

DatabaseFilters.prototype.getFilters = function() {
  var filters = {};

  var selectedFilters = this.$filtersSelect.find("option:selected");
  selectedFilters.each(function(index, selectedFilter) {
    var field = $(selectedFilter).attr('name');
    var value = $(selectedFilter).attr('value');
    filters[field] = filters[field] ? filters[field].push(value) : [value];

  });

  var checkedboxes =  $('.filter :checked');
  checkedboxes.each(function(index, checkbox){
    var field = $(checkbox).attr('name');
    var value = $(checkbox).attr('value');
    filters[field] = filters[field] ? filters[field].push(value) : [value];
  });

  return filters;
};

DatabaseFilters.prototype.getDisplayCount = function() {
  return { "display_count": this.$displayCountSelect.val() };
};

DatabaseFilters.prototype.updateList = function() {
  var filters = this.getFilters();
  var displayCount = this.getDisplayCount();
  var sort = this.getSort();
  var url = new URL(window.location.href).pathname;
  var newFleets = newFleets || { fleets:[] };

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    data: $.extend(filters, displayCount, sort, {
      authenticity_token: AUTH_TOKEN
    }),
    success: function(response) {
      $('.fleet-line').remove();
      newFleets.fleets = response.fleets
      this.$fleetTableBody.append(this.$newFleetTemplate(newFleets))
      this.$resultCount.html(response.result_count);
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

DatabaseFilters.prototype.setSort = function(event) {
  var thisEl = $(event.currentTarget);
  var sorted = thisEl.attr('data-sorted') === "true";
  var direction = sorted && thisEl.attr('data-sorted-direction') === "asc" ? "desc" : "asc";

  $('th[data-sorted=true]').attr('data-sorted', false)
  $('th[data-sorted-direction]').removeAttr('data-sorted-direction');
  thisEl.attr('data-sorted', true);
  thisEl.attr('data-sorted-direction', direction);

  this.updateList();
};

DatabaseFilters.prototype.getSort = function() {
  var sort = $('th[data-sorted=true]').attr('data-type');
  var direction = $('th[data-sorted=true]').attr('data-sorted-direction');
  return { "sort": sort, "direction": direction }
};

DatabaseFilters.prototype.exportToCsv = function() {
  var filters = this.getFilters();
  var displayCount = this.getDisplayCount();
  var sort = this.getSort();
  window.location.href = new URI(window.location.href + "/export.csv").addSearch(filters).addSearch(displayCount).addSearch(sort);
};
