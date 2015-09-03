EditableComponent = function() {

  this.init = function() {
    this.$inputTime = this.$el.find('.video-text-time');
    this.$inputText = this.$el.find('.video-text-display');
    this.$btnEdit = this.$el.find('.video-btn-edit');
    this.$btnSave = this.$el.find('.video-btn-save');
    this.$btnCancel = this.$el.find('.video-btn-cancel');
    this.$btnTrash = this.$el.find('.video-btn-trash');

    this.initHandlers();
  };

  this.initHandlers = function() {
    this.$btnEdit.on('click', $.proxy(this.edit, this));
    this.$btnSave.on('click', $.proxy(this.save, this));
    this.$btnCancel.on('click', $.proxy(this.cancel, this));
    this.$btnTrash.on('click', $.proxy(this.trash, this));
  };

  this.edit = function() {
    this.$el.addClass('active');

    this.originalTimeVal = this.$inputTime.val();
    this.originalTextVal = this.$inputText.val();

    this.$inputTime.prop('readonly', false);
    this.$inputText.prop('readonly', false);
  };

  this.save = function() {
    if (this.ephemeral) {
      notify.info('Your ' + this.displayClass + ' has been created.');
      this.ephemeral = false;
    } else {
      notify.info('Your ' + this.displayClass + ' has been saved.');
    }

    this.$el.removeClass('active');
    this.$inputTime.prop('readonly', true);
    this.$inputText.prop('readonly', true);
  }

  this.cancel = function() {
    if (this.ephemeral) {
      this.trash();
    } else {
      this.$el.removeClass('active');
      this.$inputTime.prop('readonly', true);
      this.$inputText.prop('readonly', true);
      this.$inputTime.val(this.originalTimeVal);
      this.$inputText.val(this.originalTextVal);
    }
  };

  this.trash = function() {
    this.remove();
  };

  this.init();
}
