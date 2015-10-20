DeleteModal = function(config) {
  this.$modal = config.modal;
  this.$btnDeleteYes = config.btnDeleteYes;
  this.$btnDeleteNo = config.btnDeleteNo;

  this.init();
};

DeleteModal.prototype.init = function() {
  this.$btnDeleteYes.on('click', $.proxy(this.hide, this));
  this.$btnDeleteNo.on('click', $.proxy(this.hide, this));
}

DeleteModal.prototype.show = function(event) {
  this.$modal.modal('show');
};

DeleteModal.prototype.hide = function(event) {
  this.$modal.modal('hide');
};
