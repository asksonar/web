Initable = function(handler) {
  this.onInit = function(handler) {
    this.initHandlers = (this.initHandlers || []).slice(0);
    this.initHandlers.push(handler);
  };

  this.init = function() {
    for(var i = 0; i < this.initHandlers.length; i++) {
      this.initHandlers[i].call(this);
    }
  };

  if (handler) {
    this.onInit(handler);
  }
};
