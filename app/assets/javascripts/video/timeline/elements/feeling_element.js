modulejs.define('FeelingDelightedElement', ['TimelineElement'], function() {
  window.FeelingDelightedElement = Object.create(TimelineElement);

  FeelingDelightedElement.onCreate(function(config) {
    this.displayClass = 'feeling-delighted';
    this.displayIcon = 'feeling-delighted';
    this.timeSeconds = config.time;
    this.displayText = "<span>User clicked</span><i class='feeling-delighted'></i>";
    this.hashid = config.hashid;
  });

});

modulejs.define('FeelingConfusedElement', ['TimelineElement'], function() {
  window.FeelingConfusedElement = Object.create(TimelineElement);

  FeelingConfusedElement.onCreate(function(config) {
    this.displayClass = 'feeling-confused';
    this.displayIcon = 'feeling-confused';
    this.timeSeconds = config.time;
    this.displayText = "<span>User clicked</span><i class='feeling-confused'></i>";
    this.hashid = config.hashid;
  });

});
