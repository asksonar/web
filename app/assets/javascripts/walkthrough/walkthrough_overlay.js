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
  this.$linkFirstResult = config.linkFirstResult;

  this.init();
}

WalkthroughOverlay.prototype.init = function() {
}

WalkthroughOverlay.prototype.show = function(target) {
  if (!target) {
    return false;
  }

  $('body').addClass('modal-open');

  var top = target.offset().top;
  var left = target.offset().left;
  var height = target.outerHeight();
  var width = target.outerWidth();

  this.$top.css({
    height: top - this.padding
  }).show();
  this.$left.css({
    top: top - this.padding,
    height: height + this.padding + this.padding,
    width: left - this.padding
  }).show();
  this.$right.css({
    top: top - this.padding,
    height: height + this.padding + this.padding,
    width: $(window).width() - width - left - this.padding
  }).show();
  this.$bottom.css({
    height: $(window).height() - top - height - this.padding
  }).show();

  return target;
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

WalkthroughOverlay.prototype.showResults = function() {
  return this.show(this.$linkFirstResult);
}

WalkthroughOverlay.prototype.showNone = function() {
  $('body').addClass('modal-open');

  this.$top.css({
    height: $(window).height()
  }).show();
  this.$left.hide();
  this.$right.hide();
  this.$bottom.hide();

  return true;
}

WalkthroughOverlay.prototype.hide = function() {
  $('body').removeClass('modal-open');

  this.$top.hide();
  this.$left.hide();
  this.$right.hide();
  this.$bottom.hide();

  return true;
}
