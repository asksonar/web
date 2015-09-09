NoteElement = function(config) {
  this.displayClass = 'note';
  this.displayIcon = 'fa fa-tag';
  this.timeSeconds = config.timeSeconds;
  this.displayText = config.displayText;
  this.resultStepHashId = config.resultStepHashId;
};

NoteElement.prototype = new TimelineElement();
NoteElement.prototype.constructor = TimelineElement;

EditableComponent.call(NoteElement.prototype);
TrashableComponent.call(NoteElement.prototype);

NoteElement.prototype.save = function() {
  this.saveSuccess();
};

NoteElement.prototype.trash = function() {
  this.trashSuccess();
};
