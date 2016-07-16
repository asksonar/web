AnalysisController = function(config, pivotTable) {
  this.$navSubContainer = config.navSubContainer;
  this.$renderersInputRadio = config.renderersInputRadio;
  this.$aggregatorsInputRadio = config.aggregatorsInputRadio;
  this.$aggregatorSelect = config.aggregatorSelect;

  this.pivotTable = pivotTable;

  this.init();
};

AnalysisController.prototype.init = function() {
  this.$navSubContainer.on('click', $.proxy(this.toggleNav, this));
  this.$renderersInputRadio.on('change', $.proxy(this.updatePivot, this));
  this.$aggregatorsInputRadio.on('change', $.proxy(this.selectAggregatorAttr, this));
  this.$aggregatorSelect.on('change', $.proxy(this.updatePivot, this));

  // row attributes
  Sortable.create(rows, {
    group: { name: 'columns', pull: true, put: true },
    animation: 200,
    onAdd: $.proxy(this.updatePivot, this),
    onUpdate: $.proxy(this.updatePivot, this)
  });

  // column attributes
  Sortable.create(columns, {
    group: { name: 'columns', pull: true, put: true },
    animation: 200,
    onAdd: $.proxy(this.updatePivot, this),
    onUpdate: $.proxy(this.updatePivot, this)
  });

  // available attributes
  Sortable.create(available, {
    group: { name: 'columns', pull: true, put: true },
    animation: 200,
    onAdd: $.proxy(this.updatePivot, this),
    onUpdate: $.proxy(this.updatePivot, this)
  });
};

AnalysisController.prototype.getRows = function() {
  var rowArray = $('.ctn-selected-attributes #rows')
    .children()
    .map(function(index, elem) { return $(elem).attr('data-id'); })
    .toArray();

  return rowArray;
};

AnalysisController.prototype.getColumns = function() {
  var colArray = $('.ctn-selected-attributes #columns')
    .children()
    .map(function(index, elem) { return $(elem).attr('data-id'); })
    .toArray();

  return colArray;
};

AnalysisController.prototype.getRenderer = function() {
  var renderer = $('.renderers :checked');
  return { name: renderer.val(), type: renderer.attr('data-renderer-type') };
};

AnalysisController.prototype.selectAggregatorAttr = function() {
  var aggregator = $('.aggregators input:checked').val();
  $('option:selected[name="aggregator"]').prop("selected", false); // unselect all selected item
  $('.bootstrap-select').not(".hidden").addClass("hidden"); // hide currently displayed dropdown

  if ( aggregator === "count" ) {
    this.updatePivot();
  } else {
    $('nav .selectpicker[name="' + aggregator + '"]').parent().removeClass("hidden");
  }
};

AnalysisController.prototype.getAggregator = function() {
  var aggregator = { name: "", params: [] };
  aggregator.name = $('.aggregators input:checked').val();
  aggregator.params.push($('option:selected[name="aggregator"]').val());
  return aggregator;
};

AnalysisController.prototype.updatePivot = function(event) {
  var rowArray = this.getRows();
  var colArray = this.getColumns();
  var renderer = this.getRenderer();
  var aggregator = this.getAggregator();

  this.pivotTable.load(rowArray, colArray, renderer, aggregator);
};

AnalysisController.prototype.toggleNav = function(event) {
  var thisEl = $(event.currentTarget);
  var icon = thisEl.find('i');

  if ( icon.hasClass('fa-chevron-down') ) {
    icon.removeClass("fa-chevron-down").addClass("fa-chevron-right");
  } else {
    icon.removeClass("fa-chevron-right").addClass("fa-chevron-down");
  }
};
