Eventable = function() {
  this.on = function(event, callback) {
    this.eventBus = this.eventBus || $({});
    this.eventBus.on(event, callback);
  };
  this.trigger = function(type, data) {
    this.eventBus = this.eventBus || $({});
    this.eventBus.trigger(type, data);
  };
};
