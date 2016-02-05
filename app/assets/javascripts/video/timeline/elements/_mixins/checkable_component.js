function CheckableComponent() {
  this.checkable = true;

  var _saveSuccess = this.saveSuccess || $.noop;
  this.saveSuccess = function(customMsg) {
    _saveSuccess.apply(this, arguments);
    this.$el.find('.video-check-show').attr('name', 'scenario_highlight[' + this.displayClass + '][' + this.hashid + ']');
  };
}
