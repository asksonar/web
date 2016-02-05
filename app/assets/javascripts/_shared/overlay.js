function Overlay(config) {
  config = config || {};
  this.$top = config.topOverlay;
  this.$left = config.leftOverlay;
  this.$right = config.rightOverlay;
  this.$bottom = config.bottomOverlay;
  this.padding = config.padding;

  this.init();
}

Overlay.prototype.init = function() {

};

Overlay.prototype.show = function(target, dismissible) {
  if (!target || target.length === 0) {
    return false;
  }

  $('body').addClass('modal-open');

  var top = target.offset().top;
  var left = target.offset().left;
  var height = target.outerHeight();
  var width = target.outerWidth();

  // var windowHeight = $(window).height();
  // var windowWidth = $(window).width();

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
    left: left + width + this.padding,
    height: height + this.padding + this.padding
  }).show();
  this.$bottom.css({
    top: top + height + this.padding
  }).show();

  if (dismissible === true) {

    var groupDismiss = function() {
      this.hide();
      this.$top.off('click');
      this.$left.off('click');
      this.$right.off('click');
      this.$bottom.off('click');
    };

    this.$top.on('click', $.proxy(groupDismiss, this));
    this.$left.on('click', $.proxy(groupDismiss, this));
    this.$right.on('click', $.proxy(groupDismiss, this));
    this.$bottom.on('click', $.proxy(groupDismiss, this));
  } else {
    this.$top.off('click');
    this.$left.off('click');
    this.$right.off('click');
    this.$bottom.off('click');
  }

  return target;
};

Overlay.prototype.showNone = function(dismissible) {
  $('body').addClass('modal-open');

  this.$top.css({
    height: '100%'
  }).show();
  this.$left.hide();
  this.$right.hide();
  this.$bottom.hide();

  if (dismissible === true) {
    this.$top.one('click', $.proxy(this.hide, this));
  }

  return true;
};

Overlay.prototype.hide = function() {
  $('body').removeClass('modal-open');

  this.$top.hide();
  this.$left.hide();
  this.$right.hide();
  this.$bottom.hide();

  return true;
};

$(function(){
  var overlay = new Overlay({
    topOverlay: $('#top-overlay'),
    leftOverlay: $('#left-overlay'),
    rightOverlay: $('#right-overlay'),
    bottomOverlay: $('#bottom-overlay'),
    padding: 5
  });

  window.overlay = overlay;
});
