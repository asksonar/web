DatabaseFilters = function(config) {
  this.$btnSelect = config.btnSelect;
  this.$btnSelectSubFilters = config.btnSelectSubFilters;
  this.$btnSelectMainFilters = config.btnSelectMainFilters;
  this.$btnAddFilter = config.btnAddFilter;
  this.$fleetTable = config.fleetTable;
  this.$newFleetTemplate = Handlebars.compile(config.newFleetTemplate.html());

  this.init();
};

DatabaseFilters.prototype.init = function() {
  this.$btnSelectMainFilters.on('change', $.proxy(this.updateSubFilters, this));
  this.$btnAddFilter.on('click', $.proxy(this.updateList, this));
};

DatabaseFilters.prototype.updateSubFilters = function() {
  // remove previous filters on re-selecting
  if ( $('option.sub-filter').length > 0 ) {
    $('option.sub-filter').remove();
    this.$btnSelect.selectpicker('refresh');
  }

  var data = this.getSelected();
  var url = new URL(window.location.href).pathname;

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    data: $.extend(data, {
      authenticity_token: AUTH_TOKEN
    }),
    success: function(response) {
      var filters = response.sub_filters;
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

DatabaseFilters.prototype.updateList = function() {
  var data = this.getSelected();
  var url = new URL(window.location.href).pathname;
  var newFleets = newFleets || {fleets:[]};

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    data: $.extend(data, {
      authenticity_token: AUTH_TOKEN
    }),
    success: function(response) {
      $('.fleet-line').remove();
      newFleets.fleets = response.fleets
      this.$fleetTable.append(this.$newFleetTemplate(newFleets))
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

DatabaseFilters.prototype.getSelected = function() {
  var filters = {
    main_filter: this.$btnSelectMainFilters.val(),
    sub_filter: this.$btnSelectSubFilters.val()
  };

  return filters;
};
