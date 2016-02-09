function WalkthroughArrow(config) {
  this.$svg = config.svg;
  this.$marker = config.svg.find('> marker');
  this.$path = config.svg.find('> path');

  this.startX = 0;
  this.startY = 0;
  this.endX = 0;
  this.endY = 0;
  this.orientation = 'horizontal';

  this.resize(config.size);

  this.init();
}

WalkthroughArrow.prototype.init = function() {

};

WalkthroughArrow.prototype.resize = function(strokeWidth) {
  this.size = strokeWidth;
  this.resizeMarker(strokeWidth + 1);
  this.resizePath(strokeWidth);
  this.draw(this.startX, this.startY, this.endX, this.endY, this.orientation);
};

WalkthroughArrow.prototype.resizeMarker = function(base) {
  this.$marker.get(0).setAttribute('markerWidth', base * 2);
  this.$marker.get(0).setAttribute('markerHeight', base * 2);
  this.$marker.get(0).setAttribute('refX', 0);
  this.$marker.get(0).setAttribute('refY', base);

  var path = 'M0,0'
    + ' L0,' + base * 2
    + ' L' + base * 2 + ',' + base
    + ' L0,0';
  this.$marker.find('path').get(0).setAttribute('d', path);

  this.markerSize = base * 2;
};

WalkthroughArrow.prototype.resizePath = function(strokeWidth) {
  this.$path.css({
    'stroke-width': strokeWidth
  });
};

WalkthroughArrow.prototype.draw = function(startX, startY, endX, endY, orientation) {
  this.startX = startX;
  this.startY = startY;
  this.endX = endX;
  this.endY = endY;
  this.orientation = orientation;

  var left = Math.min(startX, endX);
  var top = Math.min(startY, endY);

  var width = Math.abs(startX - endX);
  var height = Math.abs(startY - endY);

  if (orientation === 'horizontal') {
    height *= 1.5;
  } else if (orientation === 'vertical') {
    width *= 1;
  }

  this.$svg.css({
    left: left,
    top: top,
    width: width,
    height: height
  });

  var path = '';

  if (endX > startX) {
    path += 'M' + (startX - left);
  } else {
    path += 'M' + (startX - left);
  }

  if (endY > startY) {
    path += ',' + (startY - top);
  } else {
    path += ',' + (startY - top);
  }

  if (orientation === 'horizontal') {
    path += ' Q' + width / 2 + ',' + height;
  } else if (orientation === 'vertical') {
    path += ' Q' + width + ',' + height / 2;
  }

  if (endX > startX) {
    path += ' ' + (endX - left);
  } else {
    path += ' ' + (endX - left);
  }

  if (endY > startY) {
    path += ' ' + (endY - top);
  } else {
    path += ' ' + (endY - top);
  }

  this.$path.get(0).setAttribute('d', path);
};

WalkthroughArrow.prototype.show = function() {
  this.$svg.show();
};

WalkthroughArrow.prototype.hide = function() {
  this.$svg.hide();
};
