CheckableComponent = function() {
  this.checkable = true;

  var _saveSuccess = this.saveSuccess || $.noop;
  this.saveSuccess = function(event, response) {
    _saveSuccess.apply(this, arguments);
    this.$el.find('.video-check-show').attr('name', 'highlight[show][' + this.hashid + ']');
  };
};
