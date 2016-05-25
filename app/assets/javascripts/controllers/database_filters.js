DatabaseFilters = function(config) {
  this.$btnSelect = config.btnSelect;
  this.$btnSelectSubFilters = config.btnSelectSubFilters;
  this.$btnSelectMainFilters = config.btnSelectMainFilters;
  this.$btnAddFilter = config.btnAddFilter;
  this.$fleetTable = config.fleetTable;
  this.$filterItemsContainer = config.filterItemsContainer;
  this.$btnExportCsv = config.btnExportCsv;
  this.$resultCount = config.resultCount;
  this.$selectDisplayCount = config.selectDisplayCount;
  this.$newFleetTemplate = Handlebars.compile(config.newFleetTemplate.html());

  this.init();
};

DatabaseFilters.prototype.init = function() {
  this.$btnSelectMainFilters.on('change', $.proxy(this.updateSubFilters, this));
  this.$btnAddFilter.on('click', $.proxy(this.addFilter, this));
  this.$fleetTable.on('click', 'td', $.proxy(this.addFilter, this));
  this.$filterItemsContainer.on('click', '.filter-item', $.proxy(this.removeFilter, this));
  this.$btnExportCsv.on('click', $.proxy(this.exportToCsv, this));
  this.$selectDisplayCount.on('change', $.proxy(this.updateList, this));
};

DatabaseFilters.prototype.updateSubFilters = function() {
  // remove previous filters on re-selecting
  if ( $('option.sub-filter').length > 0 ) {
    $('option.sub-filter').remove();
    this.$btnSelect.selectpicker('refresh');
  }

  var data = { main_filter: this.$btnSelectMainFilters.val() };
  var url = new URL(window.location.href).pathname + '/sub_filters';

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    data: $.extend(data, {
      authenticity_token: AUTH_TOKEN
    }),
    success: function(filters) {
      $.each(filters, function(index) {
        this.$btnSelectSubFilters.append('<option class="sub-filter">' + filters[index] + '</option>');
      }.bind(this));

      this.$btnSelect.selectpicker('refresh');
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

DatabaseFilters.prototype.addFilter = function(event){
  var thisEl = $(event.currentTarget);
  var main_filter, sub_filter;

  if ( thisEl.attr('data-type') ) {
    main_filter = thisEl.attr('data-type');
    sub_filter = thisEl.html();
  } else {
    main_filter = this.$btnSelectMainFilters.val();
    sub_filter = this.$btnSelectSubFilters.val();
  }

  if ( this.$filterItemsContainer.children().length === 0 ) {
    this.$filterItemsContainer.append(
      '<h3>Filtered by:</h3>'
    )
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

  // remove header if there're no filters
  if ( $('.filter-items-container a').length === 0 ) {
    $('.filter-items-container h3').remove();
  }

  this.updateList();
};

DatabaseFilters.prototype.updateList = function() {
  var filters = this.getFilters();
  var displayCount = this.getDisplayCount();
  var url = new URL(window.location.href).pathname;
  var newFleets = newFleets || {fleets:[]};

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    data: $.extend(filters, displayCount, {
      authenticity_token: AUTH_TOKEN
    }),
    success: function(response) {
      $('.fleet-line').remove();
      newFleets.fleets = response.fleets
      this.$fleetTable.append(this.$newFleetTemplate(newFleets))
      this.$resultCount.html(response.result_count);
      this.resetSort();
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

DatabaseFilters.prototype.resetSort = function() {
  $('th[data-sorted=true]').attr('data-sorted', false);
}

DatabaseFilters.prototype.getDisplayCount = function() {
  return { "display_count": this.$selectDisplayCount.val() };
}

DatabaseFilters.prototype.getFilters = function() {
  var filters = {};

  $('.filter-item').each(function(index, item) {
    var main_filter =  $(item).attr('data-main-filter');
    var sub_filter =  $(item).attr('data-sub-filter');

    if ( filters[main_filter] ) {
      filters[main_filter].push(sub_filter)
    } else {
      filters[main_filter] = [sub_filter]
    }
  })

  return filters;
};

DatabaseFilters.prototype.exportToCsv = function() {
  var filters = this.getFilters();
  window.location.href = new URI(window.location.href + "/export.csv").addSearch(filters);
};
