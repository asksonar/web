Eventable = function() {
  this.on = function(event, callback) {
    // forcibly reassign this.eventBus so it doesn't muck with parents up the chain
    this.eventBus = $.extend({}, this.eventBus || $({}));
    this.eventBus.on(event, callback);
  };
  this.trigger = function(type, data) {
    this.eventBus = this.eventBus || $({});
    this.eventBus.trigger(type, data);
  };
};
