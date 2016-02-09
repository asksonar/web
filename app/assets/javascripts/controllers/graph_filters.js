GraphFilters = function(config, chart) {
  this.$inputCheckbox = config.inputCheckbox;
  this.$btnSelect = config.btnSelect;

  this.chart = chart;

  this.init();
};

GraphFilters.prototype.init = function() {
  this.$inputCheckbox.on('change', $.proxy(this.updateGraph, this));
  this.$btnSelect.on('change', $.proxy(this.updateGraph, this));
};

GraphFilters.prototype.updateGraph = function() {
  var data = this.getFilters();
  var url = new URL(window.location.href).pathname;

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    data: $.extend(data, {
      authenticity_token: AUTH_TOKEN
    }),
    success: function(response) {
      this.chart.dataProvider = response;
      this.chart.validateData();
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

GraphFilters.prototype.getFilters = function() {
  var filters = { region: [], country: [], date: null, category: null };

  var selectedFilters = this.$btnSelect.find('option:selected');
  selectedFilters.each(function(index, selectedFilter) {
    var field = $(selectedFilter).attr('name');
    var value = $(selectedFilter).attr('value');
    filters[field] = value;
  });

  var checkedboxes = $('.filter :checked');
  checkedboxes.each(function(index, checkbox) {
    var field = $(checkbox).attr('name');
    var value = $(checkbox).attr('value');
    filters[field].push(value);
  });

  return filters;
};
