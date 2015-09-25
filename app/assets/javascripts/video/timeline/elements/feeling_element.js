FeelingDelightedElement = function(config) {
  this.displayClass = 'feeling-delighted';
  this.displayIcon = 'feeling-delighted';
  this.timeSeconds = config.time;
  this.displayText = "<span>User clicked</span><i class='feeling-delighted'></i>";
  this.hashid = config.hashid;
};

FeelingDelightedElement.prototype = new TimelineElement();
FeelingDelightedElement.prototype.constructor = TimelineElement;

FeelingConfusedElement = function(config) {
  this.displayClass = 'feeling-confused';
  this.displayIcon = 'feeling-confused';
  this.timeSeconds = config.time;
  this.displayText = "<span>User clicked</span><i class='feeling-confused'></i>";
  this.hashid = config.hashid;
};

FeelingConfusedElement.prototype = new TimelineElement();
FeelingConfusedElement.prototype.constructor = TimelineElement;
