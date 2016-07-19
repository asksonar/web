AnalysisController = function(config, pivotTable) {
  this.$renderersSelect = config.renderersSelect;
  this.$aggregatorsSelect = config.aggregatorsSelect;
  this.$attributesSelect = config.attributesSelect;

  this.pivotTable = pivotTable;

  this.init();
};

AnalysisController.prototype.init = function() {
  this.$aggregatorsSelect.on('change', $.proxy(this.toggleAttributesSelect, this));
  this.$renderersSelect.on('change', $.proxy(this.updatePivot, this));
  this.$attributesSelect.on('change', $.proxy(this.updatePivot, this));

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
  var renderer = $('option:selected[name="renderer"]');
  return { name: renderer.val(), type: renderer.attr('data-renderer-type') };
};

AnalysisController.prototype.toggleAttributesSelect = function() {
  var aggregator = $('option:selected[name="aggregator"]').val();

  if (aggregator === "count") {
    $('option:selected[name="attribute"]').prop("selected", false);
    this.$attributesSelect.prop('disabled', true);
    this.$attributesSelect.selectpicker('refresh');
    this.updatePivot();
  } else {
    this.$attributesSelect.prop('disabled', false);
    this.$attributesSelect.selectpicker('refresh');
  }
};

AnalysisController.prototype.getAggregator = function() {
  var aggregator = { name: "", params: [] };
  aggregator.name = $('option:selected[name="aggregator"]').val();

  var attribute = $('option:selected[name="attribute"]').val();
  if (attribute) {
    aggregator.params.push(attribute);
  }

  return aggregator
};

AnalysisController.prototype.updatePivot = function(event) {
  var rowArray = this.getRows();
  var colArray = this.getColumns();
  var renderer = this.getRenderer();
  var aggregator = this.getAggregator();

  this.pivotTable.load(rowArray, colArray, renderer, aggregator);
};
