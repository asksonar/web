function StudiesController(view, url, config) {
  this.view = view;
  this.url = url;

  this.$btnInstallExtension = config.btnInstallExtension;
  this.$btnStartFeedback = config.btnStartFeedback;

  this.init();
  this.initListeners();
}

StudiesController.prototype.init = function() {
  this.$btnInstallExtension.on('click', $.proxy(this.installExtension, this));
  this.$btnStartFeedback.on('click', $.proxy(this.startFeedback, this));
}

StudiesController.prototype.initListeners = function() {

}

StudiesController.prototype.hasChrome = function() {
  return chrome && chrome.webstore && chrome.webstore.install;
}

StudiesController.prototype.hasExtension = function() {
  return this.hasChrome() && chrome.app.isInstalled;
}

StudiesController.prototype.installExtension = function() {
  var notificationController = new NotificationController();

  var successCallback = function() {
    this.refresh();
    notificationController.info('Extension successfully activated.');
  };

  var failureCallback = function() {
    notificationController.error('There was an error activating the extension.');
  };

  chrome.webstore.install(this.url, $.proxy(successCallback, this), $.proxy(failureCallback, this));
}

StudiesController.prototype.launchExtension = function() {
  this.view.completeStartFeedback();
}

StudiesController.prototype.refresh = function() {
  if (this.hasChrome()) {
    this.view.completeInstallChrome();
    this.view.enableInstallExtension();
  } else {
    this.view.enableInstallChrome();
    this.view.disableInstallExtension();
    this.view.disableStartFeedback();
    return;
  }

  if (this.hasExtension()) {
    this.view.completeInstallExtension();
    this.view.enableStartFeedback();
  } else {
    this.view.enableInstallExtension();
    this.view.disableStartFeedback();
  }
}
