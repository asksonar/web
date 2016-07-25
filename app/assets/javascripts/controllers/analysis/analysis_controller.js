AnalysisController = function(config, pivotTable) {
  this.$renderersSelect = config.renderersSelect;
  this.$aggregatorsSelect = config.aggregatorsSelect;
  this.$attributesSelect = config.attributesSelect;
  this.$ctnSelectedAttributes = config.ctnSelectedAttributes;
  this.$btnUpdateFilter = config.btnUpdateFilter;
  this.$btnSelectAll = config.btnSelectAll;
  this.$btnSelectNone = config.btnSelectNone;

  this.pivotTable = pivotTable;

  this.init();
};

AnalysisController.prototype.init = function() {
  this.$aggregatorsSelect.on('change', $.proxy(this.toggleAttributesSelect, this));
  this.$renderersSelect.on('change', $.proxy(this.updatePivot, this));
  this.$attributesSelect.on('change', $.proxy(this.updatePivot, this));
  this.$ctnSelectedAttributes.on('click', 'li i', $.proxy(this.showFilterBox, this));
  this.$btnUpdateFilter.on('click', $.proxy(this.updateFilters, this));
  this.$btnSelectAll.on('click', $.proxy(this.selectAll, this));
  this.$btnSelectNone.on('click', $.proxy(this.selectNone, this));

  // filter attribtues
  Sortable.create(filters, {
    group: { name: 'analysis', pull: true, put: true },
    animation: 200
  });

  // row attributes
  Sortable.create(rows, {
    group: { name: 'analysis', pull: true, put: true },
    animation: 200,
    onAdd: $.proxy(this.updatePivot, this),
    onUpdate: $.proxy(this.updatePivot, this)
  });

  // column attributes
  Sortable.create(columns, {
    group: { name: 'analysis', pull: true, put: true },
    animation: 200,
    onAdd: $.proxy(this.updatePivot, this),
    onUpdate: $.proxy(this.updatePivot, this)
  });

  // available attributes
  Sortable.create(available, {
    group: { name: 'analysis', pull: true, put: true },
    animation: 200,
    onAdd: $.proxy(this.toggleAttributeCaret, this),
    onRemove: $.proxy(this.toggleAttributeCaret, this)
  });
};

AnalysisController.prototype.selectAll = function(event) {
  var thisEl = $(event.currentTarget);
  var checkContainer = thisEl.parent().siblings('.pvtCheckContainer');
  var filters = checkContainer.find('.pvtFilter');
  filters.prop('checked', true);
};

AnalysisController.prototype.selectNone = function(event) {
  var thisEl = $(event.currentTarget);
  var checkContainer = thisEl.parent().siblings('.pvtCheckContainer');
  var filters = checkContainer.find('.pvtFilter');
  filters.prop('checked', false);
};

AnalysisController.prototype.toggleAttributeCaret = function(event) {
  var attribute = $(event.item);
  var from = $(event.from).attr('id');

  if (from === "available") {
    attribute.find('i').removeClass('fa-bars').addClass('fa-caret-down');
  } else {
    attribute.find('i').removeClass('fa-caret-down').addClass('fa-bars');
  }
  this.updatePivot();
}

AnalysisController.prototype.showFilterBox = function(event) {
  var thisEl = $(event.currentTarget);
  var attribute = thisEl.parent().attr('data-id');
  var filterBox = $('.pvtFilterBox[data-attribute="' + attribute + '"]');
  var position = thisEl.offset();
  var clickLeft = position.left;
  var clickTop = position.top;

  filterBox.css({
    left: clickLeft + 10 - 300, // 300 sidebar width
    top: clickTop + 10
  }).show();
};

AnalysisController.prototype.updateFilters = function(event) {
  var thisEl = $(event.currentTarget);
  var filterBox = thisEl.closest('.pvtFilterBox');
  filterBox.hide();
  this.updatePivot();
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

AnalysisController.prototype.getFilters = function() {
  var unchecked = $("input:checkbox:not(:checked)");
  var filters = {};
  $.each(unchecked, function(key, filter) {
    var filterAttribute = $(filter).attr('data-attribute');
    var filterName = $(filter).siblings('span').text();
    if ($('.ctn-selected-attributes li[data-id="' + filterAttribute+ '"]').length === 0) {
      return;
    }
    if (filters[filterAttribute]) {
      filters[filterAttribute].push(filterName);
    } else {
      filters[filterAttribute] = [filterName];
    }
  });
  return filters;
};

AnalysisController.prototype.getRenderer = function() {
  var renderer = $('option:selected[name="renderer"]');
  return { name: renderer.val(), type: renderer.attr('data-renderer-type') };
};

AnalysisController.prototype.toggleAttributesSelect = function() {
  var aggregator = $('option:selected[name="aggregator"]').val();
  var attribute = $('option:selected[name="attribute"]');

  if (aggregator === "count") {
    attribute.prop("selected", false);
    this.$attributesSelect.prop('disabled', true);
    this.$attributesSelect.selectpicker('refresh');
    this.updatePivot();
  } else if (attribute.length === 0) {
    this.$attributesSelect.prop('disabled', false);
    this.$attributesSelect.selectpicker('refresh');
  } else {
    this.updatePivot();
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
  var filters = this.getFilters();
  var renderer = this.getRenderer();
  var aggregator = this.getAggregator();

  this.pivotTable.load(rowArray, colArray, filters, renderer, aggregator);
};
