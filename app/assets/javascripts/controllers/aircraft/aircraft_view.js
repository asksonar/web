function AircraftView(config, aircraftHistoryUpdateModal) {
  this.$divAllContent = config.divAllContent;

  this.aircraftHistoryUpdateModal = aircraftHistoryUpdateModal;

  this.initHandlers();
}

AircraftView.prototype.initHandlers = function() {
  this.$divAllContent.on('click', '.link-submit-changes', $.proxy(this.loadAircraftHistoryUpdateModal, this));
};

AircraftView.prototype.loadAircraftHistoryUpdateModal = function(event) {
  event.preventDefault();
  var thisEl = $(event.currentTarget);
  var aircraftHashId = thisEl.attr('data-aircraft-hashid');
  var aircraftHistoryHashId = thisEl.attr('data-aircraft-history-hashid');

  this.aircraftHistoryUpdateModal.load(aircraftHashId, aircraftHistoryHashId);
};
