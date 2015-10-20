DeleteModal = function(config) {
  this.$modal = config.modal;
  this.$btnDeleteYes = config.btnDeleteYes;
  this.$btnDeleteNo = config.btnDeleteNo;

  this.init();
};

DeleteModal.prototype.init = function() {
  this.$btnDeleteYes.on('click', $.proxy(this.deleteStudy, this));
  this.$btnDeleteNo.on('click', $.proxy(this.hide, this));
}

DeleteModal.prototype.show = function(event) {
  this.$modal.modal('show');
};

DeleteModal.prototype.hide = function(event) {
  this.$modal.modal('hide');
};

DeleteModal.prototype.deleteStudy = function(event) {
  this.hide();
  var url = '/' + sonar.request.controller + '/' + sonar.scenario.hashid;

  $.ajax({
    type: 'POST',
    url: url,
    data: {
      _method: 'DELETE',
      authenticity_token: AUTH_TOKEN
    }
  })
    .success(function(data){
      window.location.replace(data.redirect_url);
    })
    .fail($.proxy(function(jqXHR){
      notify.error(jqXHR.responseText);
    }, this));
};