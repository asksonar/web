modulejs.define('TranscriptElement', ['TimelineElement'], function(timelineElement) {
  var transcriptElement = Object.create(timelineElement, {
    modulez: { value: 'TranscriptElement' }
  });

  EditableComponent.call(transcriptElement);

  transcriptElement.onCreate(function(config) {
    this.displayClass = 'transcript';
    this.displayIcon = 'fa fa-align-left';
    this.timeSeconds = config.time;
    this.displayText = config.text;
    this.hashid = config.hashid;
    this.resultStepHashId = config.resultStepHashId;
  });

  transcriptElement.save = function() {
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
      },
      success: function(response) {
        this.setTime(response.time);
        this.setText(response.text);
        this.saveSuccess();
      }.bind(this),
      error: function() {
        this.saveFail();
      }.bind(this)
    });
  };

  return transcriptElement;
});
