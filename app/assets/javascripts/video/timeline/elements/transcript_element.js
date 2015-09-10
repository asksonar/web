TranscriptElement = function(config) {
  this.displayClass = 'transcript';
  this.displayIcon = 'fa fa-align-left';
  this.timeSeconds = config.timeSeconds;
  this.displayText = config.displayText;
  this.hashid = config.hashid;
  this.resultStepHashId = config.resultStepHashId;
};

TranscriptElement.prototype = new TimelineElement();
TranscriptElement.prototype.constructor = TimelineElement;

EditableComponent.call(TranscriptElement.prototype);

TranscriptElement.prototype.save = function() {
  var time = this.$inputTime.val();
  var text = this.$inputText.val();

  time = this.displayTimeToSecs(time);
  if (isNaN(time)) {
    return this.saveFail('Please enter time in the format HH:MM.');
  }
  text = text.trim();
  if (text.length === 0) {
    return this.saveFail('Please enter your transcription text.');
  }

  $.ajax({
    type: 'POST',
    url: '/transcripts/' + this.hashid,
    data: {
      _method: 'PATCH',
      time: time,
      text: text,
      authenticity_token: AUTH_TOKEN
    }
  }).success($.proxy(function(response) {
    this.$inputText.val(response.text);
    this.$inputTime.val(this.secsToDisplayTime(response.timeSeconds));
    this.saveSuccess();
  }, this)).fail($.proxy(function() {
    this.saveFail();
  }, this));
};
