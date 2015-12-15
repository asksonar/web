TrashableComponent = function() {
  this.trashable = true;

  this.onInit(function() {
    this.$btnTrash = this.$el.find('.video-btn-trash');

    this.$btnTrash.on('click', $.proxy(this.trash, this));
  });

  this.trashSuccess = function() {
    this.$el.trigger('stopEditing');
    this.remove();
    notify.info('Your ' + this.displayClass + ' has been removed.');
  };

  this.trashFail = function(customMsg) {
    if (typeof customMsg === 'string') {
      notify.warn(customMsg);
    } else {
      notify.warn('There was an error removing your  ' + this.displayClass + '.');
    }
  };

};
