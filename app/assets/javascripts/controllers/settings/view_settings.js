ViewSettings = function(config) {
  this.$survey_settings = config.survey_settings;
  this.$survey = $('.survey');

  this.init();
};

ViewSettings.prototype.init = function() {
  this.$survey_settings.off().on('keyup', $.proxy(this.updateView, this));
};

ViewSettings.prototype.updateView = function(event) {
  var updatedField = $(event.target).attr('data-customize-field');
  var updatedValue = $(event.target).val();
  var $target = this.$survey.find('#' + updatedField);

  if (updatedValue.length === 0) {
    $target.text("us");
  } else {
    $target.text(updatedValue);
  }
};


