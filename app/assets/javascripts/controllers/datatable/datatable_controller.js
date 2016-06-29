DatatableController = function(config) {
  this.$btnEditMode = config.btnEditMode;
  this.$btnEditColumn = config.btnEditColumn;
  this.$btnMoveLeft = config.btnMoveLeft;
  this.$btnMoveRight = config.btnMoveRight;
  this.$columnHeader = config.columnHeader;
  this.$navSubContainer = config.navSubContainer;
  this.$btnCollapseSidebar = config.btnCollapseSidebar;
  this.$btnExpandSidebar = config.btnExpandSidebar;
  this.$mainWrapper = config.mainWrapper;
  this.$mainContentHeader = config.mainContentHeader;

  this.init();
};

DatatableController.prototype.init = function() {
  this.$btnEditMode.on('click', $.proxy(this.toggleEdit, this));
  this.$btnMoveLeft.on('click', $.proxy(this.moveColumnLeft, this));
  this.$btnMoveRight.on('click', $.proxy(this.moveColumnRight, this));
  this.$navSubContainer.on('click', $.proxy(this.toggleNav, this));
  this.$btnExpandSidebar.on('click', $.proxy(this.toggleSidebar, this));
  this.$btnCollapseSidebar.on('click', $.proxy(this.toggleSidebar, this));
};

DatatableController.prototype.toggleNav = function(event) {
  var thisEl = $(event.currentTarget);
  var icon = thisEl.find('i');

  if ( icon.hasClass('fa-chevron-down') ) {
    icon.removeClass("fa-chevron-down").addClass("fa-chevron-right");
  } else {
    icon.removeClass("fa-chevron-right").addClass("fa-chevron-down");
  }
};

DatatableController.prototype.toggleSidebar = function(event) {
  this.$mainWrapper.toggleClass('sidebar-collapsed');
  this.$btnExpandSidebar.toggleClass('hide');
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
