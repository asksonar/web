function StudiesView(config) {
  this.$ctnInstallChrome = config.ctnInstallChrome;
  this.$ctnInstallExtension = config.ctnInstallExtension;
  this.$ctnSetup = config.ctnSetup;
  this.$ctnHelp = config.ctnHelp;
  this.$ctnStartFeedback = config.ctnStartFeedback;

  this.init();
}

StudiesView.prototype.init = function() {
  this.enableInstallChrome();
  this.disableInstallExtension();
  this.disableStartFeedback();
}

StudiesView.prototype.enableStep = function(element) {
  element.addClass('step-enabled');
  element.removeClass('step-disabled');
  element.removeClass('step-completed');
}

StudiesView.prototype.disableStep = function(element) {
  element.removeClass('step-enabled');
  element.addClass('step-disabled');
  element.removeClass('step-completed');
}

StudiesView.prototype.completeStep = function(element) {
  element.removeClass('step-enabled');
  element.removeClass('step-disabled');
  element.addClass('step-completed');
}

StudiesView.prototype.enableInstallChrome = function() {
  this.enableStep(this.$ctnInstallChrome);
}

StudiesView.prototype.disableInstallChrome = function() {
  this.disableStep(this.$ctnInstallChrome);
}

StudiesView.prototype.completeInstallChrome = function() {
  this.completeStep(this.$ctnInstallChrome);
}

StudiesView.prototype.enableInstallExtension = function() {
  this.enableStep(this.$ctnInstallExtension);
}

StudiesView.prototype.disableInstallExtension = function() {
  this.disableStep(this.$ctnInstallExtension);
}

StudiesView.prototype.completeInstallExtension = function() {
  this.completeStep(this.$ctnInstallExtension);
}

StudiesView.prototype.enableStartFeedback = function() {
  this.enableStep(this.$ctnStartFeedback);
  this.$ctnSetup.hide();
  this.$ctnHelp.show();
}

StudiesView.prototype.disableStartFeedback = function() {
  this.disableStep(this.$ctnStartFeedback);
  this.$ctnSetup.show();
  this.$ctnHelp.hide();
}

StudiesView.prototype.completeStartFeedback = function() {
  this.completeStep(this.$ctnStartFeedback);
  this.$ctnSetup.hide();
  this.$ctnHelp.show();
}
