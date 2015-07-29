function WalkthroughView(config, overlay) {
  this.$start = config.start;
  this.$one = config.one;
  this.$oneBee = config.oneBee;
  this.$two = config.two;
  this.$three = config.three;
  this.$threeBee = config.threeBee;
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

WalkthroughView.prototype.showOne = function() {
  this.$one.show();
  this.$one.find('i').popover('show');
}

WalkthroughView.prototype.showOneBee = function() {
  this.$one.hide();
  this.$oneBee.show();
  this.$oneBee.find('i').popover('show');
}

WalkthroughView.prototype.showTwo = function() {
  this.$two.show();
  this.$two.find('i').popover('show');
}

WalkthroughView.prototype.showThree = function() {
  this.$three.show();
  this.$three.find('i').popover('show');
}

WalkthroughView.prototype.showThreeBee = function() {
  this.$three.hide();
  this.$threeBee.show();
  this.$threeBee.find('i').popover('show');
}

WalkthroughView.prototype.showFinish = function() {
  this.$three.hide();
  this.$threeBee.hide();
  this.$finish.show();
  this.$finish.find('i').popover('show');
}


