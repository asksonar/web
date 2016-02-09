Creatable = function(handler) {

  this.onCreate = function(handler) {
    // forcibly reassign this.initHandlers so it doesn't muck with parents up the chain
    this.createHandlers = (this.createHandlers || []).slice(0);
    this.createHandlers.push(handler);
  };

  this.create = function() {
    var created = Object.create(this);
    for (var i = 0; i < this.createHandlers.length; i++) {
      this.createHandlers[i].apply(created, arguments);
    }
    return created;
  };

  if (handler) {
    this.onCreate(handler);
  }
};
