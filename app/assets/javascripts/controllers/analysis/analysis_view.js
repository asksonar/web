AnalysisView = function(config, analysisController) {
  this.$btnSaveView = config.btnSaveView;
  this.$inputSaveView = config.inputSaveView;
  this.$divSavedViews = config.divSavedViews;
  this.$deleteModal = config.deleteModal;
  this.$btnDeleteYes = config.btnDeleteYes;
  this.$modalTrigger = undefined;

  this.$analysisController = analysisController;

  this.init();
};

AnalysisView.prototype.init = function() {
  this.$btnSaveView.on('click', $.proxy(this.saveView, this));
  this.$deleteModal.on('show.bs.modal', $.proxy(this.updateTrigger, this));
  this.$btnDeleteYes.on('click', $.proxy(this.deleteView, this));
};

AnalysisView.prototype.updateTrigger = function(event) {
  this.$modalTrigger = $(event.relatedTarget);
};

AnalysisView.prototype.saveView = function() {
  var name = this.$inputSaveView.val();

  var pivot_params = {
    "rowArray": this.$analysisController.getRows(),
    "colArray": this.$analysisController.getColumns(),
    "filters": this.$analysisController.getFilters(),
    "renderer": this.$analysisController.getRenderer(),
    "aggregator": this.$analysisController.getAggregator()
  };

  var url = '/analysis/views/';
  this.$inputSaveView.val('');

  $.ajax({
    type: 'POST',
    dataType: 'json',
    url: url,
    data: {
      name: name,
      pivot_params: pivot_params,
      authenticity_token: AUTH_TOKEN
    },
    success: function(data) {
      notify.info("Your view has been saved.");
      var divider = "<li class='divider'></li>";
      var newView = "<li><a href='/analysis/views/" + data.hashid + "'>" + data.name + "</a>\
                    <span class='close' data-analysis-view-hashid=" + data.hashid + " data-toggle='modal' \
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

AnalysisView.prototype.deleteView = function(event) {
  var hashid = this.$modalTrigger.attr('data-analysis-view-hashid');
  var url = '/analysis/views/' + hashid;

  $.ajax({
    type: 'POST',
    url: url,
    data: {
      _method: 'DELETE',
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
