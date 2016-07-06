DatatableView = function(config, datatableFilters) {
  this.$btnSaveView = config.btnSaveView;
  this.$inputSaveView = config.inputSaveView;
  this.$divSavedViews = config.divSavedViews;

  this.datatableFilers = datatableFilters;

  this.init();
};

DatatableView.prototype.init = function() {
  this.$btnSaveView.on('click', $.proxy(this.saveView, this));
};

DatatableView.prototype.saveView = function() {
  var name = this.$inputSaveView.val();
  var datatable_filters = this.datatableFilers.getFilters();
  var datatable_columns = this.datatableFilers.getColumns();
  var url = '/fleets/datatable_views/';
  this.$inputSaveView.val('');

  $.ajax({
    type: 'POST',
    dataType: 'json',
    url: url,
    data: {
      name: name,
      datatable_filters: datatable_filters,
      datatable_columns: datatable_columns,
      authenticity_token: AUTH_TOKEN
    },
    success: function(data) {
      notify.info("Your view has been saved.");
      var newView = "<li class='divider'></li><li><a href='/fleets/datatable_views/" + data.hashid + "'>" + data.name + "</a></li>";
      this.$divSavedViews.append(newView);
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
}
