DeleteModal = function(config) {
  this.$modal = config.modal;
  this.$btnDeleteYes = config.btnDeleteYes;

  this.init();
};

DeleteModal.prototype.init = function() {
  this.$btnDeleteYes.on('click', $.proxy(this.deleteWithAjax, this));
};

DeleteModal.prototype.deleteWithAjax = function(event) {
  var url = '/' + sonar.request.controller + '/' + sonar.scenario.hashid;

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
