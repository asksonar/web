function StudiesController(extension, view, config) {
  this.extension = extension;
  this.view = view;

  this.$btnInstallExtension = config.btnInstallExtension;
  this.$btnStartFeedback = config.btnStartFeedback;
  this.$form = config.form;

  this.init();
}

StudiesController.prototype.init = function() {
  this.$btnInstallExtension.on('click', $.proxy(this.installExtension, this));
  this.$btnStartFeedback.on('click', $.proxy(this.startFeedback, this));
};

StudiesController.prototype.checkForChrome = function() {
  if (!this.extension.hasChrome()) {
    this.view.showInstallChrome();
    return false;
  } else {
    this.view.showInstallExtension();
    return true;
  }
};

StudiesController.prototype.checkForExtension = function() {
  if (!this.checkForChrome()) {
    return;
  }

  this.extension.checkForExtension()
    .done(
      function() {
        this.view.showStudy();
      }.bind(this)
    )
    .fail(
      function() {
        this.view.showInstallExtension();
      }.bind(this)
    );
};

StudiesController.prototype.installExtension = function() {
  this.extension.installExtension()
    .done(
      function() {
        this.view.showStudy(true);
      }.bind(this)
    );
};

StudiesController.prototype.startFeedback = function() {
  this.extension.startFeedback(this.$form.serialize())
    .done(
      function() {
        this.view.startStudy();
      }
    );
};
