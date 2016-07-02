DatatableView = function(config, datatableFilters) {
  this.$btnSaveChanges = config.btnSaveChanges;
  this.$btnSaveView = config.btnSaveView;
  this.$inputSaveView = config.inputSaveView;
  this.$divSavedViews = config.divSavedViews;
  this.$columnsSelected = Sortable.create(selected, { group: { name: 'columns', pull: true, put: true }, animation: 200 });
  this.$columnsAvailable = Sortable.create(available, { group: { name: 'columns', pull: true, put: true }, animation: 200 });

  this.datatableFilers = datatableFilters;

  this.init();
};

DatatableView.prototype.init = function() {
  this.$btnSaveChanges.on('click', $.proxy(this.saveChanges, this));
  this.$btnSaveView.on('click', $.proxy(this.saveView, this));
};

DatatableView.prototype.saveView = function() {
  var name = this.$inputSaveView.val();
  var filters = this.datatableFilers.getFilters();
  var datatable_columns = this.getColumns();
  var url = '/fleets/datatable_views/';

  $.ajax({
    type: 'POST',
    dataType: 'json',
    url: url,
    data: {
      name: name,
      filters: filters,
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

DatatableView.prototype.getColumns = function() {
  var columnsSelected = this.$columnsSelected.toArray();
  var columnsAvailable = this.$columnsAvailable.toArray();
  return { "selected": columnsSelected, "available": columnsAvailable };
}

DatatableView.prototype.saveChanges = function(event) {
  var thisEl = $(event.currentTarget);
  var id = thisEl.attr('datatable-view-hashid');
  var datatable_columns = this.getColumns();
  var url = '/fleets/datatable_views/' + id + '/edit';

  $.ajax({
    type: 'POST',
    dataType: 'json',
    url: url,
    data: {
      datatable_columns: datatable_columns,
      authenticity_token: AUTH_TOKEN
    },
    success: function(data) {
      window.location.replace('/fleets');
      notify.info("Your changes have been updated.");
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};
