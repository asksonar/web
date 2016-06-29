DatatableModal = function(config) {
  this.$btnSaveChanges = config.btnSaveChanges;
  this.$columnsSelected = Sortable.create(selected, { group: { name: 'columns', pull: true, put: true }, animation: 200 });
  this.$columnsAvailable = Sortable.create(available, { group: { name: 'columns', pull: true, put: true }, animation: 200 });

  this.init();
};

DatatableModal.prototype.init = function() {
  this.$btnSaveChanges.on('click', $.proxy(this.saveChanges, this));
};

DatatableModal.prototype.saveChanges = function() {
  var columnsSelected = this.$columnsSelected.toArray();
  var columnsAvailable = this.$columnsAvailable.toArray();
  var datatable_columns = { "selected": columnsSelected, "available": columnsAvailable };
  var url = new URL(window.location.href).pathname + '/settings';
  
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
