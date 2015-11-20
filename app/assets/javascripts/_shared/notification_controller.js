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
    z_index: 1051 /* to beat the modal z-index of 1050 */
  });
}

NotificationController.prototype.info = function(message) {
  $.notify(message, { delay: 2000 });
}

NotificationController.prototype.warn = function(message, defaultMessage) {
  // hack for error-catching
  if (message && message.length > 300) {
    message = defaultMessage || 'There was an error processing your request.'
  }

  $.notify(message, { delay: 5000 });
}

NotificationController.prototype.error = function(message, defaultMessage, handler) {
  // hack for error-catching
  if (message && message.length > 300) {
    message = defaultMessage || 'There was an error processing your request.'
  }

  var notify = $.notify(message);
  notify.$ele.find('a').on('click', handler);
}

window.notify = new NotificationController();
