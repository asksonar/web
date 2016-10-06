$(function(){

  if ($('#aircraft-show').length === 0) {
    return;
  }

  var aircraftHistoryUpdateModal = new AircraftHistoryUpdateModal({
    modal: $('#aircraft-history-update-container'),
    divAircraftHistorydetails: $('#aircraft-history-update-container .details-container'),
    aircraftHistoryDetailsTemplate: $('#aircraft-history-details-template'),
    btnSaveChanges: $('#btn-save-changes'),
    btnDeleteHistory: $('#btn-delete-history'),
    inputUserComment: $('textarea#user-comment')
  });

  window.view = new AircraftView({
    divAllContent: $('.main-content-wrapper')
  }, aircraftHistoryUpdateModal);
});
