function WalkthroughView(config, overlay) {
  this.$start = config.start;
  this.$template = config.template;
  this.$create = config.create;
  this.$share = config.share;
  this.$results = config.results;
  this.$modal = config.modal;
  this.$finish = config.finish;


  this.overlay = overlay;

  this.init();
  this.initHandlers();
}

WalkthroughView.prototype.init = function() {
}

WalkthroughView.prototype.initHandlers = function() {
}

WalkthroughView.prototype.showStart = function() {
  this.$start.show();
  this.$start.find('i').popover('show');
}

WalkthroughView.prototype.showTemplate = function() {
  this.$template.show();
  this.$template.find('i').popover('show');
}

WalkthroughView.prototype.showCreate = function() {
  this.$create.show();
  this.$create.find('i').popover('show');
}

WalkthroughView.prototype.showShare = function() {
  this.$share.show();
  this.$share.find('i').popover('show');
}

WalkthroughView.prototype.showResults = function() {
  this.$results.show();
  this.$results.find('i').popover('show');
}

WalkthroughView.prototype.showModal = function() {
  this.$results.hide();
  this.$modal.fadeIn();
  this.$modal.find('i').popover('show');
}

WalkthroughView.prototype.showFinish = function() {
  this.$results.hide();
  this.$modal.hide();
  this.$finish.fadeIn();
  this.$finish.find('i').popover('show');
}


