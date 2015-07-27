function StudiesController(view, appId, config) {
  this.view = view;
  this.appId = appId;

  this.$btnInstallExtension = config.btnInstallExtension;
  this.$btnStartFeedback = config.btnStartFeedback;
  this.$form = config.form;

  this.init();
  this.initHandlers();
}

StudiesController.prototype.init = function() {
}

StudiesController.prototype.initHandlers = function() {
  this.$btnInstallExtension.on('click', $.proxy(this.installExtension, this));
  this.$btnStartFeedback.on('click', $.proxy(this.startFeedback, this));
}

StudiesController.prototype.hasChrome = function() {
  return window.chrome && chrome.webstore && chrome.webstore.install;
}

StudiesController.prototype.checkForChrome = function() {
  if (!this.hasChrome()) {
    this.view.showInstallChrome();
    return false;
  } else {
    this.view.showInstallExtension();
    return true;
  }
}

StudiesController.prototype.checkForExtension = function() {
  if (!this.checkForChrome()) {
    return;
  }

  var responseCallback = function(response) {
    if (response === true) {
      this.view.showStudy();
      this.checkForExtensionUpdate();
    } else {
      this.view.showInstallExtension();
    }
  };

  chrome.runtime.sendMessage(this.appId, 'isInstalledApp?', $.proxy(responseCallback, this));
}

StudiesController.prototype.checkForExtensionUpdate = function() {

  var responseCallback = function(response) {
    if (response !== true) {
      notify.warn('The extension needs to be updated.  Please refresh the page and try again.');
    }
  }
  chrome.runtime.sendMessage(this.appId, 'update!', $.proxy(responseCallback, this));
}

StudiesController.prototype.installExtension = function() {
  var successCallback = function() {
    this.view.showStudy(true);
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
      this.view.startStudy();
    } else if (typeof response === "string") {
      notify.warn(response);
    } else {
      notify.warn('There was an error launching the study.');
    }
  }

  var ajaxDone = function(response) {
    var launchAppParams = {};
    launchAppParams['scenario'] = scenarioParams;
    launchAppParams['scenarioResultHashId'] = response.hashid;
    launchAppParams['screen'] = {
      availLeft: screen.availLeft,
      availTop: screen.availTop,
      availWidth: screen.availWidth,
      availHeight: screen.availHeight
    }

    chrome.runtime.sendMessage(this.appId, {launchApp: launchAppParams}, $.proxy(launchedAppResponse, this));
  }

  $.ajax({
    url: '/studies',
    method: 'POST',
    data: this.$form.serialize(),
    dataType: 'json'
  }).done($.proxy(ajaxDone, this)).fail(function(jqXHR) {
    notify.error(jqXHR.responseText, 'There was an error starting your study.');
  });
}
