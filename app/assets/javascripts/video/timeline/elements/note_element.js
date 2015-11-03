modulejs.define('NoteElement', ['TimelineElement'], function(timelineElement) {
  var noteElement = Object.create(timelineElement, {
    modulez: { value: 'NoteElement' }
  });

  EditableComponent.call(noteElement);
  TrashableComponent.call(noteElement);

  noteElement.onCreate(function(config) {
    this.displayClass = 'note';
    this.displayIcon = 'fa fa-tag';
    this.timeSeconds = config.time;
    this.displayText = config.text;
    this.hashid = config.hashid;
    this.scenarioResultHashId = config.scenarioResultHashId;
  });

  noteElement.save = function() {
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
        scenario_result_hashid: this.scenarioResultHashId,
        authenticity_token: AUTH_TOKEN
      }
    }).success($.proxy(function(response) {
      this.trigger('saveSuccess', response);
    }, this)).fail($.proxy(function() {
      this.trigger('saveFail', response);
    }, this));
  };

  var _saveSuccess = noteElement.saveSuccess || $.noop;
  noteElement.saveSuccess = function(event, response) {
    _saveSuccess.apply(this, arguments);
    this.hashid = response.hashid;
    this.setTime(response.time);
    this.setText(response.text);
  };

  noteElement.trash = function() {
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

  return noteElement;
});
