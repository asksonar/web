modulejs.define('StepElement', ['TimelineElement'], function(timelineElement) {
  var stepElement = Object.create(timelineElement, {
    modulez: { value: 'StepElement' }
  });

  stepElement.onCreate(function(config) {
    this.displayClass = 'step';
    this.displayIcon = 'fa fa-list-ul';
    this.timeSeconds = config.time;
    this.displayText = 'Step ' + config.order + '. ' + config.text;
    this.hashid = config.hashid;
    this.scenarioResultHashId = config.scenarioResultHashId;
  });

  return stepElement;
});

