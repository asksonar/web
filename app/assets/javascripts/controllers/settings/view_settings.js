function ViewSettings(config) {
  this.$companyProductName = config.companyProductName;
  this.$survey = config.survey;
  this.$backgroundColor = config.backgroundColor;

  this.init();
}

ViewSettings.prototype.init = function() {
  this.$companyProductName.on('keyup', $.proxy(this.updateName, this));

  this.$backgroundColor.spectrum({
    color: this.$survey.css('background-color'),
    preferredFormat: "hex",
    showInput: true,
    replacerClassName: 'color-picker-replacer',
    containerClassName: 'color-picker-container',
    move: (function(color) {
      this.updateBackgroundColor(color.toHexString());
    }).bind(this),
    change: (function(color) {
      this.updateBackgroundColor(color.toHexString());
    }).bind(this)
  });
};

ViewSettings.prototype.updateName = function(event) {
  var thisEl = $(event.currentTarget);
  var updatedElement = thisEl.attr('data-style-elements');
  var updatedValue = thisEl.val();
  var $target = this.$survey.find('#' + updatedElement);

  if (updatedValue.length === 0) {
    $target.text("us");
  } else {
    $target.text(updatedValue);
  }
};

ViewSettings.prototype.updateBackgroundColor = function(color) {
  this.$survey.css( "background-color", color);
};
