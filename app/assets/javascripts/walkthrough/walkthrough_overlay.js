function WalkthroughOverlay(config) {
  this.$top = config.topOverlay;
  this.$left = config.leftOverlay;
  this.$right = config.rightOverlay;
  this.$bottom = config.bottomOverlay;
  this.padding = config.padding;

  this.$btnCreate = config.btnCreate;
  this.$btnTemplate = config.btnTemplate;
  this.$btnPublish = config.btnPublish;
  this.$panelHero = config.panelHero;
  this.$btnCopyLink = config.btnCopyLink;
  this.$linkFirstResult = config.linkFirstResult;

  this.init();
}

WalkthroughOverlay.prototype = new Overlay();
WalkthroughOverlay.prototype.constructor = Overlay;

WalkthroughOverlay.prototype.init = function() {
}

WalkthroughOverlay.prototype.showCreate = function() {
  return this.show(this.$btnCreate);
}

WalkthroughOverlay.prototype.showTemplate = function() {
  return this.show(this.$btnTemplate);
}

WalkthroughOverlay.prototype.showDropdown = function() {
  return this.show(this.$btnTemplate.find('li').first());
}

WalkthroughOverlay.prototype.showPublish = function() {
  return this.show(this.$btnPublish);
}

WalkthroughOverlay.prototype.showHero = function() {
  return this.show(this.$panelHero);
}

WalkthroughOverlay.prototype.showCopyLink = function() {
  return this.show(this.$btnCopyLink);
}

WalkthroughOverlay.prototype.showResults = function() {
  return this.show(this.$linkFirstResult);
}
