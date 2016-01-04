ViewSettings = function(config) {
  this.$companyProductName = config.companyProductName;
  this.$survey = config.survey;

  this.init();
};

ViewSettings.prototype.init = function() {
  this.$companyProductName.off().on('keyup', $.proxy(this.updateName, this));
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
