TranscriptElement = function(config, el) {
  this.displayClass = 'transcript';
  this.displayIcon = 'fa fa-align-left';
  this.timeSeconds = config.timeSeconds;
  this.displayText = config.displayText;

  EditableComponent.call(this);
};

TranscriptElement.prototype = new TimelineElement();
TranscriptElement.prototype.constructor = TimelineElement;
