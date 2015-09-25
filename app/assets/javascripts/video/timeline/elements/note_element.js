NoteElement = function(config) {
  this.displayClass = 'note';
  this.displayIcon = 'fa fa-tag';
  this.timeSeconds = config.time;
  this.displayText = config.text;
  this.hashid = config.hashid;
  this.resultStepHashId = config.resultStepHashId;
};

NoteElement.prototype = new TimelineElement();
NoteElement.prototype.constructor = TimelineElement;

EditableComponent.call(NoteElement.prototype);
TrashableComponent.call(NoteElement.prototype);

NoteElement.prototype.save = function() {
  var time = this.$inputTime.val();
  var text = this.$inputText.val();

  time = this.displayTimeToSecs(time);
  if (isNaN(time)) {
    return this.saveFail('Please enter time in the format HH:MM.');
  }
  text = text.trim();
  if (text.length === 0) {
    return this.saveFail('Please enter your note text.');
  }

  var url = '/notes/';
  var method = 'POST';
  if (this.getState() === 'editing') {
    url += this.hashid;
    method = 'PATCH';
  }

  $.ajax({
    type: 'POST',
    url: url,
    data: {
      _method: method,
      time: time,
      text: text,
      result_step_hashid: this.resultStepHashId,
      authenticity_token: AUTH_TOKEN
    }
  }).success($.proxy(function(response) {
    this.hashid = response.hashid;
    this.setTime(response.time);
    this.setText(response.text);
    this.saveSuccess();
  }, this)).fail($.proxy(function() {
    this.saveFail();
  }, this));
};

NoteElement.prototype.trash = function() {
  var time = this.$inputTime.val();
  var text = this.$inputText.val();

  time = this.displayTimeToSecs(time);
  text = text.trim();

  $.ajax({
    type: 'POST',
    url: '/notes/' + this.hashid,
    data: {
      _method: 'DELETE',
      authenticity_token: AUTH_TOKEN
    }
  }).success($.proxy(function(response) {
    this.trashSuccess();
  }, this)).fail($.proxy(function() {
    this.trashFail();
  }, this));
};
