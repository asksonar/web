NoteElement = function(config, el) {
  this.displayClass = 'note';
  this.displayIcon = 'fa fa-tag';
  this.timeSeconds = config.timeSeconds;
  this.displayText = config.displayText;

  EditableComponent.call(this);
};

NoteElement.prototype = new TimelineElement();
NoteElement.prototype.constructor = TimelineElement;
