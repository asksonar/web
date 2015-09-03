FeelingDelightedElement = function(config) {
  this.displayClass = 'feeling-delighted';
  this.displayIcon = 'feeling-delighted';
  this.timeSeconds = config.timeSeconds;
  this.displayText = "<span>User clicked</span><i class='feeling-delighted'></i>";
  this.editComponent = ReadonlyComponent;
  this.editable = false;
}

FeelingDelightedElement.prototype = new TimelineElement();
FeelingDelightedElement.prototype.constructor = TimelineElement;

FeelingConfusedElement = function(config, el) {
  this.displayClass = 'feeling-confused';
  this.displayIcon = 'feeling-confused';
  this.timeSeconds = config.timeSeconds;
  this.displayText = "<span>User clicked</span><i class='feeling-confused'></i>";
  this.editComponent = ReadonlyComponent;
  this.editable = false;
}

FeelingConfusedElement.prototype = new TimelineElement();
FeelingConfusedElement.prototype.constructor = TimelineElement;
