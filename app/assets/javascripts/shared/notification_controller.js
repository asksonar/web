function NotificationController() {
  this.init();
}

NotificationController.prototype.init = function() {
  $.notifyDefaults({
    type: 'notification',
    placement: {
      from: 'top',
      align: 'center'
    },
    allow_dismiss: true,
    delay: 0,
    animate: {
      enter: 'animated fadeInDown',
      exit: 'animated fadeOutUp'
    },
  });
}

NotificationController.prototype.info = function(message) {
  $.notify(message, { delay: 2000 });
}

NotificationController.prototype.error = function(message) {
  $.notify(message);
}
