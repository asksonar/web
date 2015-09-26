modulejs.define('FeelingDelightedElement', ['TimelineElement'], function(timelineElement) {
  var feelingDelightedElement = Object.create(timelineElement, {
    clazz: { value: 'FeelingDelightedElement' }
  });

  feelingDelightedElement.onCreate(function(config) {
    this.displayClass = 'feeling-delighted';
    this.displayIcon = 'feeling-delighted';
    this.timeSeconds = config.time;
    this.displayText = "<span>User clicked</span><i class='feeling-delighted'></i>";
    this.hashid = config.hashid;
  });

  return feelingDelightedElement;
});

modulejs.define('FeelingConfusedElement', ['TimelineElement'], function(timelineElement) {
  var feelingConfusedElement = Object.create(timelineElement);

  feelingConfusedElement.onCreate(function(config) {
    this.displayClass = 'feeling-confused';
    this.displayIcon = 'feeling-confused';
    this.timeSeconds = config.time;
    this.displayText = "<span>User clicked</span><i class='feeling-confused'></i>";
    this.hashid = config.hashid;
  });

  return feelingConfusedElement;
});
