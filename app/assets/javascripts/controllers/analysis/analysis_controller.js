AnalysisController = function(config) {
  this.$navSubContainer = config.navSubContainer;

  this.init();
}

AnalysisController.prototype.init = function() {
  this.$navSubContainer.on('click', $.proxy(this.toggleNav, this));
  this.$rowAttributes = Sortable.create(rows, { group: { name: 'columns', pull: true, put: true }, animation: 200 });
  this.$columnAttributes = Sortable.create(columns, { group: { name: 'columns', pull: true, put: true }, animation: 200 });
  this.$availableAttributes = Sortable.create(available, { group: { name: 'columns', pull: true, put: true }, animation: 200 });
}

AnalysisController.prototype.toggleNav = function(event) {
  var thisEl = $(event.currentTarget);
  var icon = thisEl.find('i');

  if ( icon.hasClass('fa-chevron-down') ) {
    icon.removeClass("fa-chevron-down").addClass("fa-chevron-right");
  } else {
    icon.removeClass("fa-chevron-right").addClass("fa-chevron-down");
  }
}
