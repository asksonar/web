DatatableController = function(config) {
  this.$navSubContainer = config.navSubContainer;
  this.$btnCollapseSidebar = config.btnCollapseSidebar;
  this.$btnExpandSidebar = config.btnExpandSidebar;
  this.$mainWrapper = config.mainWrapper;
  this.$mainContentHeader = config.mainContentHeader;

  this.init();
};

DatatableController.prototype.init = function() {
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
