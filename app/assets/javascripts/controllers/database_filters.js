DatabaseFilters = function(config) {
  this.$btnSelect = config.btnSelect;
  // this.$btnSelectSubFilters = config.btnSelectSubFilters;
  // this.$btnSelectMainFilters = config.btnSelectMainFilters;
  this.$btnAddFilter = config.btnAddFilter;
  this.$fleetTable = config.fleetTable;
  this.$fleetTableBody = config.fleetTableBody;
  this.$filterItemsContainer = config.filterItemsContainer;
  this.$btnExportCsv = config.btnExportCsv;
  this.$resultCount = config.resultCount;
  this.$displayCountSelect = config.displayCountSelect;
  this.$inputCheckbox = config.inputCheckbox;
  this.$filtersSelect = config.filtersSelect;

  this.$newFleetTemplate = Handlebars.compile(config.newFleetTemplate.html());

  this.init();
};

DatabaseFilters.prototype.init = function() {
  // this.$btnSelectMainFilters.on('change', $.proxy(this.updateSubFilters, this));
  this.$btnAddFilter.on('click', $.proxy(this.addFilter, this));
  this.$fleetTable.on('click', 'td', $.proxy(this.addFilter, this));
  this.$fleetTable.on('click', 'th', $.proxy(this.setSort, this));
  this.$filterItemsContainer.on('click', '.filter-item', $.proxy(this.removeFilter, this));
  this.$btnExportCsv.on('click', $.proxy(this.exportToCsv, this));
  this.$displayCountSelect.on('change', $.proxy(this.updateList, this));
  this.$inputCheckbox.on('change', $.proxy(this.updateList, this));
  this.$filtersSelect.on('change', $.proxy(this.updateList, this));
};

// DatabaseFilters.prototype.updateSubFilters = function() {
//   // remove previous filters on re-selecting
//   if ( $('option.sub-filter').length > 0 ) {
//     $('option.sub-filter').remove();
//     this.$btnSelect.selectpicker('refresh');
//   }
//
//   var data = { main_filter: $('.selectpicker option:selected').attr('data-type') };
//   var url = new URL(window.location.href).pathname + '/sub_filters';
//
//   $.ajax({
//     type: 'GET',
//     dataType: 'json',
//     url: url,
//     data: $.extend(data, {
//       authenticity_token: AUTH_TOKEN
//     }),
//     success: function(filters) {
//       $.each(filters, function(index) {
//         this.$btnSelectSubFilters.append('<option class="sub-filter">' + filters[index] + '</option>');
//       }.bind(this));
//       this.$btnSelect.selectpicker('refresh');
//     }.bind(this),
//     error: function(jqXHR) {
//       notify.error(jqXHR.responseText);
//     }.bind(this)
//   });
// };

DatabaseFilters.prototype.addFilter = function(event){
  var thisEl = $(event.currentTarget);
  var main_filter, sub_filter;

  if ( thisEl.attr('data-type') ) {
    main_filter = thisEl.attr('data-type');
    sub_filter = thisEl.html();
  } else {
    main_filter = $('.selectpicker option:selected').attr('data-type');
    sub_filter = this.$btnSelectSubFilters.val();
  }

  // unhide filter items container
  if ( $('.filter-items-container a').length === 0  ) {
    this.$filterItemsContainer.toggleClass('hide');
  }

  // only add filter item if it hasn't already been added
  if ( $('a[data-sub-filter="' + sub_filter + '"]').length === 0 ) {
    this.$filterItemsContainer.append(
      '<a class="btn btn-light-blue filter-item" data-main-filter="' + main_filter + '[]"data-sub-filter="' + sub_filter + '">' + sub_filter + '<span class="close">&times;</span></a>'
    )
  }

  this.updateList();
};

DatabaseFilters.prototype.removeFilter = function(event){
  var thisEl = $(event.currentTarget);
  thisEl.remove();

  // hide filter items container if there're no filters
  if ( $('.filter-items-container a').length === 0 ) {
    this.$filterItemsContainer.toggleClass('hide');
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
    filters[field] = filters[field] ? filters[field].push(value) : [value]
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
