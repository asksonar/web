AircraftHistoryUpdateModal = function(config) {
  this.$divAircraftHistorydetails = config.divAircraftHistorydetails;
  this.$btnSaveChanges = config.btnSaveChanges;
  this.$btnDeleteHistory = config.btnDeleteHistory;
  this.$modal = config.modal;

  this.$aircraftHistoryDetailsTemplate = Handlebars.compile(config.aircraftHistoryDetailsTemplate.html());

  this.init();
};

AircraftHistoryUpdateModal.prototype.init = function() {
  this.$btnSaveChanges.on('click', $.proxy(this.saveChanges, this));
  this.$btnDeleteHistory.on('click', $.proxy(this.deleteHistory, this));
};

AircraftHistoryUpdateModal.prototype.show = function() {
  this.$modal.modal('show');
};

AircraftHistoryUpdateModal.prototype.hide = function() {
  this.$modal.modal('hide');
};

AircraftHistoryUpdateModal.prototype.load = function(aircraftHashId, aircraftHistoryHashId) {
  $.ajax({
    url:"/aircraft_history.json",
    data: {
      authenticity_token: AUTH_TOKEN,
      aircraftHashId: aircraftHashId,
      aircraftHistoryHashId: aircraftHistoryHashId
    },
    dataType: 'json',
    success: this.loaded.bind(this),
    error: function(jqXHR) {
      notify.warn(jqXHR.responseText);
    }
  });
};

AircraftHistoryUpdateModal.prototype.loaded = function(data) {
  this.$divAircraftHistorydetails.html(this.$aircraftHistoryDetailsTemplate(data));
  this.show();
};

AircraftHistoryUpdateModal.prototype.saveChanges = function() {
  var thisEl = $(event.currentTarget)
  var updateCtn = thisEl.closest('#aircraft-history-update-container').find('.details-container');

  var msn = updateCtn.find('input[name=msn]').val();
  var deliveryDateStr = updateCtn.find('input[name=delivery_date]').val();
  var deliveryDate = moment(deliveryDateStr).format('YYYY-MM-DD');
  var aircraftModel = updateCtn.find('input[name=aircraft_model]').val();
  var aircraftId = updateCtn.find('input[name=aircraft_id]').val();
  var aircraftHistoryId = updateCtn.find('input[name=aircraft_history_id]').val();

  var url = '/aircraft/' + aircraftId + '/history/' + aircraftHistoryId;

  var aircraft_histories = {};
  var updates = updateCtn.find('input[type=text]').filter(function(){ return this.value.length > 0;})
  updates.each(function(index, update) {
    var key = $(update).attr('name');
    var value = $(update).val();
    aircraft_histories[key] = value;
  });

  $.ajax({
    type: 'POST',
    url: url,
    data: {
      _method: 'PATCH',
      authenticity_token: AUTH_TOKEN,
      msn: msn,
      delivery_date: deliveryDate,
      aircraft_model: aircraftModel,
      aircraft_histories: aircraft_histories
    },
    dataType: 'json',
    success: function() {
      notify.info("Your suggestion has been submitted.");
      this.hide();
    }.bind(this),
    error: function(jqXHR) {
      notify.warn(jqXHR.responseText);
    }
  });
};

AircraftHistoryUpdateModal.prototype.deleteHistory = function(event) {
  var thisEl = $(event.currentTarget)
  var updateCtn = thisEl.closest('#aircraft-history-update-container').find('.details-container');

  var msn = updateCtn.find('input[name=msn]').val();
  var deliveryDateStr = updateCtn.find('input[name=delivery_date]').val();
  var deliveryDate = moment(deliveryDateStr).format('YYYY-MM-DD');
  var aircraftModel = updateCtn.find('input[name=aircraft_model]').val();
  var aircraftId = updateCtn.find('input[name=aircraft_id]').val();
  var aircraftHistoryId = updateCtn.find('input[name=aircraft_history_id]').val();

  var url = '/aircraft/' + aircraftId + '/history/' + aircraftHistoryId;

  $.ajax({
    type: 'POST',
    url: url,
    data: {
      _method: 'DELETE',
      authenticity_token: AUTH_TOKEN,

    },
    dataType: 'json',
    success: function() {
      notify.info("Your suggestion has been submitted.");
      this.hide();
    }.bind(this),
    error: function(jqXHR) {
      notify.warn(jqXHR.responseText);
    }
  });
};
