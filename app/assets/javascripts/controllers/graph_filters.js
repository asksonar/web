GraphFilters = function(config, chart) {
  this.$inputCheckBox = config.inputCheckBox;
  this.$btnSelectDate = config.btnSelectDate;

  this.chart = chart;

  this.init();
};

GraphFilters.prototype.init = function() {
  this.$inputCheckBox.on('click', $.proxy(this.updateGraph, this));
  this.$btnSelectDate.on('change', $.proxy(this.updateGraph, this));
};

GraphFilters.prototype.updateGraph = function() {
  var data = this.getFilters();

  $.ajax({
    type: 'POST',
    url: new URL(window.location.href).pathname,
    data: $.extend(data, {
      _method: 'PATCH',
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
  var filters = {region: [], country: [], date: null};

  var selectedDate = this.$btnSelectDate.find("option:selected").val();
  filters.date = selectedDate;

  var checkedboxes = this.$inputCheckBox.find("input:checked");
  if (checkedboxes.length !== 0) {
    checkedboxes.each(function(index, checkbox){
      var field = $(checkbox).attr('name');
      var value = $(checkbox).attr('value');
      filters[field].push(value);
    });
  }

  return filters;
};
