function StudiesController(view, appId, config) {
  this.view = view;
  this.appId = appId;

  this.$btnInstallExtension = config.btnInstallExtension;
  this.$btnStartFeedback = config.btnStartFeedback;
  this.$form = config.form;

  this.init();
  this.initListeners();
}

StudiesController.prototype.init = function() {
  this.$btnInstallExtension.on('click', $.proxy(this.installExtension, this));
  this.$btnStartFeedback.on('click', $.proxy(this.startFeedback, this));

  this.view.enableInstallChrome();
  this.view.disableInstallExtension();
  this.view.disableStartFeedback();
}

StudiesController.prototype.initListeners = function() {
}

StudiesController.prototype.hasChrome = function() {
  return chrome && chrome.webstore && chrome.webstore.install;
}

StudiesController.prototype.checkForExtension = function() {
  if (!this.hasChrome()) {
    return;
  }

  this.view.enableInstallExtension();

  var responseCallback = function(response) {
    if (response === true) {
      this.view.completeInstallExtension();
      this.view.enableStartFeedback();
    }
  };

  chrome.runtime.sendMessage(this.appId, 'isInstalledApp?', $.proxy(responseCallback, this));
}

StudiesController.prototype.installExtension = function() {
  var successCallback = function() {
    this.refresh();
    notify.info('Extension successfully activated.');
  };

  var failureCallback = function() {
    notify.warn('There was an error activating the extension.');
  };

  chrome.webstore.install("https://chrome.google.com/webstore/detail/" + this.appId,
    $.proxy(successCallback, this), $.proxy(failureCallback, this));
}

StudiesController.prototype.startFeedback = function() {
  var launchedAppResponse = function(response) {
    if (response === true) {
      this.view.completeStartFeedback();
    } else {
      notify.warn('There was an error launching the study.');
    }
  }

  var ajaxDone = function(response) {
    var launchAppParams = {};
    launchAppParams[response.hashid] = scenarioParams;

    chrome.runtime.sendMessage(this.appId, {launchApp: launchAppParams}, $.proxy(launchedAppResponse, this));
  }

  $.ajax({
    url: '/studies',
    method: 'POST',
    data: this.$form.serialize(),
    dataType: 'json'
  }).done($.proxy(ajaxDone, this));
}

StudiesController.prototype.refresh = function() {
  if (this.hasChrome()) {
    this.view.completeInstallChrome();
    this.checkForExtension();
  }
}
