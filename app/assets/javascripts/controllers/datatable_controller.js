DatatableController = function(config) {
  this.$btnEditMode = config.btnEditMode;
  this.$btnEditColumn = config.btnEditColumn;
  this.$btnMoveLeft = config.btnMoveLeft;
  this.$btnMoveRight = config.btnMoveRight;
  this.$columnHeader = config.columnHeader;

  this.init();
};

DatatableController.prototype.init = function() {
  this.$btnEditMode.on('click', $.proxy(this.toggleEdit, this));
  this.$btnMoveLeft.on('click', $.proxy(this.moveColumnLeft, this));
  this.$btnMoveRight.on('click', $.proxy(this.moveColumnRight, this));
};

DatatableController.prototype.toggleEdit = function() {
  this.$btnEditColumn.toggleClass('hide');
};

DatatableController.prototype.moveColumnLeft = function(event) {
  var thisEl = $(event.currentTarget).closest('th');
  var fromIndex = thisEl.index();
  var toIndex = fromIndex - 1;

  if ( toIndex < 0 ) return;

  var rows = $('table tr');
  var cols;
  rows.each(function() {
    cols = $(this).children('th, td');
    cols.eq(fromIndex).detach().insertBefore(cols.eq(toIndex));
  });
};

DatatableController.prototype.moveColumnRight = function(event) {
  var thisEl = $(event.currentTarget).closest('th');
  var fromIndex = thisEl.index();
  var toIndex = fromIndex + 1;
  var lastColumnIndex = this.$columnHeader.length - 1;

  if ( toIndex > lastColumnIndex ) return;

  var rows = $('table tr');
  var cols;
  rows.each(function() {
    cols = $(this).children('th, td');
    cols.eq(fromIndex).detach().insertAfter(cols.eq(toIndex));
  });
};
