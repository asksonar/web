function ExtensionController(appId) {
  this.appId = appId;
}

ExtensionController.prototype.hasChrome = function() {
  return window.chrome && chrome.webstore && chrome.webstore.install;
}

ExtensionController.prototype.checkForExtension = function() {
  var deferred = $.Deferred();
  var responseCallback = function(response) {
    if (response === true) {
      this.checkForExtensionUpdate();
      deferred.resolve();
    } else {
      deferred.reject();
    }
  };

  chrome.runtime.sendMessage(this.appId, 'isInstalledApp?', $.proxy(responseCallback, this));

  return deferred;
}

ExtensionController.prototype.checkForExtensionUpdate = function() {
  var deferred = $.Deferred();

  var responseCallback = function(response) {
    if (response !== true) {
      notify.warn('The extension needs to be updated.  Please refresh the page and try again.');
      deferred.reject();
    } else {
      deferred.resolve();
    }
  }
  chrome.runtime.sendMessage(this.appId, 'update!', $.proxy(responseCallback, this));

  return deferred;
}

ExtensionController.prototype.installExtension = function() {
  var deferred = $.Deferred();

  var successCallback = function() {
    notify.info('Extension successfully activated.');
    deferred.resolve();
  };

  var failureCallback = function() {
    notify.warn('There was an error activating the extension.');
    deferred.reject();
  };

  chrome.webstore.install("https://chrome.google.com/webstore/detail/" + this.appId,
    $.proxy(successCallback, this), $.proxy(failureCallback, this));

  return deferred;
}

ExtensionController.prototype.startFeedback = function(data, flowType) {
  var deferred = $.Deferred();

  var launchedAppResponse = function(response) {
    if (response === true) {
      deferred.resolve();
    } else if (typeof response === "string") {
      notify.warn(response);
      deferred.reject();
    } else {
      notify.warn('There was an error launching the study.');
      deferred.reject();
    }
  }

  var ajaxDone = function(response) {
    var launchAppParams = {
      'scenario': sonar.scenario,
      'scenarioResultHashId': response.hashid,
      'screen': {
        availLeft: screen.availLeft,
        availTop: screen.availTop,
        availWidth: screen.availWidth,
        availHeight: screen.availHeight
      },
      'flowType': flowType
    };

    chrome.runtime.sendMessage(this.appId, {launchApp: launchAppParams}, $.proxy(launchedAppResponse, this));
  }

  $.ajax({
    url: '/studies',
    method: 'POST',
    data: data,
    dataType: 'json'
  }).done($.proxy(ajaxDone, this)).fail(function(jqXHR) {
    notify.error(jqXHR.responseText, 'There was an error starting your study.');
    deferred.reject();
  });

  return deferred;
}
