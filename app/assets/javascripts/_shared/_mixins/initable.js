Initable = function(handler) {
  this.onInit = function(handler) {
    // forcibly reassign this.initHandlers so it doesn't muck with parents up the chain
    this.initHandlers = (this.initHandlers || []).slice(0);
    this.initHandlers.push(handler);
  };

  this.init = function() {
    this.initHandlers = this.initHandlers || [];
    for (var i = 0; i < this.initHandlers.length; i++) {
      this.initHandlers[i].call(this);
    }
  };

  if (handler) {
    this.onInit(handler);
  }
};
