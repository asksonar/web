EditableComponent = function() {
  this.editable = true;

  this.initEdit = function() {
    this.$inputTime = this.$el.find('.video-text-time');
    this.$inputText = this.$el.find('.video-text-display');
    this.$btnEdit = this.$el.find('.video-btn-edit');
    this.$btnSave = this.$el.find('.video-btn-save');
    this.$btnCancel = this.$el.find('.video-btn-cancel');
    this.$btnTrash = this.$el.find('.video-btn-trash');

    this.initEditHandlers();
  };

  this.initEditHandlers = function() {
    this.$btnEdit.on('click', $.proxy(this.edit, this));
    this.$btnSave.on('click', $.proxy(this.save, this));
    this.$btnCancel.on('click', $.proxy(this.cancel, this));
    this.$btnTrash.on('click', $.proxy(this.trash, this));
  };

  this.edit = function() {
    this.$el.trigger('startEditing');
    this.$el.addClass('active');

    this.originalTimeVal = this.$inputTime.val();
    this.originalTextVal = this.$inputText.val();

    this.$inputTime.prop('readonly', false);
    this.$inputText.prop('readonly', false);
  };

  this.saveSuccess = function(customMsg) {
    this.$el.trigger('stopEditing');

    if (this.ephemeral) {
      this.ephemeral = false;
    }

    if (typeof customMsg === 'string') {
      notify.warn(customMsg);
    } else if (this.ephemeral) {
      notify.info('Your ' + this.displayClass + ' has been created.');
    } else {
      notify.info('Your ' + this.displayClass + ' has been saved.');
    }

    this.$el.removeClass('active');
    this.$inputTime.prop('readonly', true);
    this.$inputText.prop('readonly', true);
  };

  this.saveFail = function(customMsg) {
    if (typeof customMsg === 'string') {
      notify.warn(customMsg);
    } else if (this.ephemeral) {
      notify.warn('There was an error creating your  ' + this.displayClass + '.');
    } else {
      notify.warn('There was an error saving your ' + this.displayClass + '.');
    }
  };

  this.cancel = function() {
    this.$el.trigger('stopEditing');
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

  this.trashSuccess = function() {
    this.$el.trigger('stopEditing');
    this.remove();
  };

  this.trashFail = function() {
    notify.warn('There was an error removing your  ' + this.displayClass + '.');
  };

};
