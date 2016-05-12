DatabaseFilters = function(config) {
  this.$btnSelect = config.btnSelect;
  this.$btnSelectSubFilters = config.btnSelectSubFilters;
  this.$btnSelectMainFilters = config.btnSelectMainFilters;
  this.$btnAddFilter = config.btnAddFilter;

  this.init();
};

DatabaseFilters.prototype.init = function() {
  // this.$btnAddFilter.on('click', $.proxy(this.updateList, this));
  this.$btnSelect.on('change', $.proxy(this.updateSubFilters, this));
};

DatabaseFilters.prototype.updateSubFilters = function() {
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
      $.each(response, function(index) {
        this.$btnSelectSubFilters.append('<option>' + response[index] + '</option>');
      }.bind(this));

      this.$btnSelect.selectpicker('refresh');
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

DatabaseFilters.prototype.getSelected = function() {
  var filters = {
    main_filter: this.$btnSelectMainFilters.val(),
    sub_filter: this.$btnSelectSubFilters.val(),
   };

  return filters;
  // var filters = {region: [], country: [], date: null, category: null};
  //
  // var selectedFilters = this.$btnSelect.find("option:selected");
  // selectedFilters.each(function(index, selectedFilter) {
  //   var field = $(selectedFilter).attr('name');
  //   var value = $(selectedFilter).attr('value');
  //   filters[field] = value;
  // });
  //
  // return filters;
};
