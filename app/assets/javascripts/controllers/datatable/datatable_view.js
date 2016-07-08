DatatableView = function(config, datatableFilters) {
  this.$btnSaveView = config.btnSaveView;
  this.$inputSaveView = config.inputSaveView;
  this.$divSavedViews = config.divSavedViews;
  this.$deleteModal = config.deleteModal;
  this.$btnDeleteYes = config.btnDeleteYes;
  this.$modalTrigger = undefined;

  this.datatableFilers = datatableFilters;

  this.init();
};

DatatableView.prototype.init = function() {
  this.$btnSaveView.on('click', $.proxy(this.saveView, this));
  this.$deleteModal.on('show.bs.modal', $.proxy(this.updateTrigger, this));
  this.$btnDeleteYes.on('click', $.proxy(this.deleteView, this));
};

DatatableView.prototype.updateTrigger = function(event) {
  this.$modalTrigger = $(event.relatedTarget);
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
      var divider = "<li class='divider'></li>";
      var newView = "<li><a href='/fleets/datatable_views/" + data.hashid + "'>" + data.name + "</a>\
                    <span class='close' data-datatable-view-hashid=" + data.hashid + " data-toggle='modal' \
                    data-target='#delete-with-ajax'>\<i class='fa fa-times-circle-o'></i></span></li>";
      
      if ($('.saved-views li').length > 0) {
        this.$divSavedViews.append(divider + newView);
      } else {
        this.$divSavedViews.append(newView);
      }
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

DatatableView.prototype.deleteView = function(event) {
  var hashid = this.$modalTrigger.attr('data-datatable-view-hashid');
  var url = '/fleets/datatable_views/' + hashid + '/delete';

  $.ajax({
    type: 'POST',
    url: url,
    data: {
      // _method: 'DELETE',
      authenticity_token: AUTH_TOKEN
    },
    success: function(data){
      window.location.replace(data.redirect_url);
    },
    error: function(jqXHR){
      if (jqXHR.status == 403) {
        window.location.replace("/403");
      } else {
        notify.error(jqXHR.responseText);
      }
    }
  });
};
