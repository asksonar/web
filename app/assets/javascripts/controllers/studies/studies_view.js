function StudiesView(config) {
  this.$ctnInstallChrome = config.ctnInstallChrome;
  this.$ctnInstallExtension = config.ctnInstallExtension;
  this.$ctnStudy = config.ctnStudy;
  this.$ctnStartFeedback = config.ctnStartFeedback;
  this.$ctnRestartFeedback = config.ctnRestartFeedback;

  this.init();
}

StudiesView.prototype.init = function() {
};

StudiesView.prototype.showInstallChrome = function() {
  this.$ctnInstallChrome.show();
  this.$ctnInstallExtension.hide();
  this.$ctnStudy.hide();
};

StudiesView.prototype.showInstallExtension = function() {
  this.$ctnInstallChrome.hide();
  this.$ctnInstallExtension.show();
  this.$ctnStudy.hide();
};

StudiesView.prototype.showStudy = function(animate) {
  this.$ctnInstallChrome.hide();

  this.$ctnStartFeedback.show();
  this.$ctnRestartFeedback.hide();

  if (animate === true) {
    this.$ctnInstallExtension.slideUp();
    this.$ctnStudy.slideDown();
  } else {
    this.$ctnInstallExtension.hide();
    this.$ctnStudy.show();
  }
};

StudiesView.prototype.startStudy = function() {
  this.$ctnInstallChrome.hide();
  this.$ctnInstallExtension.hide();
  this.$ctnStudy.show();
  this.$ctnStartFeedback.hide();
  this.$ctnRestartFeedback.hide().fadeIn();
  window.overlay.showNone(true);
};

