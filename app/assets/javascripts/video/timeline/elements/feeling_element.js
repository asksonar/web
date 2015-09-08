FeelingDelightedElement = function(config) {
  this.displayClass = 'feeling-delighted';
  this.displayIcon = 'feeling-delighted';
  this.timeSeconds = config.timeSeconds;
  this.displayText = "<span>User clicked</span><i class='feeling-delighted'></i>";
};

FeelingDelightedElement.prototype = new TimelineElement();
FeelingDelightedElement.prototype.constructor = TimelineElement;
ReadonlyComponent.call(FeelingDelightedElement.prototype);

FeelingConfusedElement = function(config) {
  this.displayClass = 'feeling-confused';
  this.displayIcon = 'feeling-confused';
  this.timeSeconds = config.timeSeconds;
  this.displayText = "<span>User clicked</span><i class='feeling-confused'></i>";
};

FeelingConfusedElement.prototype = new TimelineElement();
FeelingConfusedElement.prototype.constructor = TimelineElement;
ReadonlyComponent.call(FeelingConfusedElement.prototype);
