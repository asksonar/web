AnalysisController = function(config, pivotTable) {
  this.$renderersSelect = config.renderersSelect;
  this.$aggregatorsSelect = config.aggregatorsSelect;
  this.$attributesSelect = config.attributesSelect;
  this.$ctnSelectedAttributes = config.ctnSelectedAttributes;
  this.$rowAttributes = config.rowAttributes;
  this.$columnAttributes = config.columnAttributes;
  this.$btnUpdateFilter = config.btnUpdateFilter;
  this.$btnSelectAll = config.btnSelectAll;
  this.$btnSelectNone = config.btnSelectNone;
  this.$inputFilter = config.inputFilter;
  this.$filterAttributes = config.filterAttributes;

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
  this.$inputFilter.on('keyup', $.proxy(this.filterResults));

  // filter attributes
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

AnalysisController.prototype.showFilterBox = function(event) {
  var thisEl = $(event.currentTarget);
  var attribute = thisEl.parent().attr('data-id');
  var filterBox = $('.pvtFilterBox[data-attribute="' + attribute + '"]');
  var position = thisEl.offset();
  var clickLeft = position.left;
  var clickTop = position.top;
  this.$inputFilter.val('');
  this.$filterAttributes.show();

  filterBox.css({
    left: clickLeft + 10 - 300, // 300 sidebar width
    top: clickTop + 10
  }).show();
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

AnalysisController.prototype.filterResults = function(event) {
  var input = $(this).val().toLowerCase();
  var checkContainer = $(this).parent().siblings('.pvtCheckContainer');
  var filters = checkContainer.children();

  filters.each(function(key, value) {
    var filterIndex = $(value).text().trim().toLowerCase().indexOf(input);
    if (filterIndex === -1) {
      $(this).hide();
    } else {
      $(this).show();
    }
  });
};

AnalysisController.prototype.updateFilters = function(event) {
  var thisEl = $(event.currentTarget);
  var filterBox = thisEl.closest('.pvtFilterBox');
  filterBox.hide();
  this.updatePivot();
};

AnalysisController.prototype.toggleAttributeCaret = function(event) {
  var attribute = $(event.item);
  var attributeName = attribute.attr('data-id');
  var origin = $(event.from).attr('id');

  $('.pvtFilter[data-attribute="' + attributeName + '"]').prop('checked', true);

  if (origin === "available") {
    attribute.find('i').removeClass('fa-bars').addClass('fa-caret-down');
  } else {
    attribute.find('i').removeClass('fa-caret-down').addClass('fa-bars');
  }

  this.updatePivot();
};

AnalysisController.prototype.getRows = function() {
  var rowArray = this.$rowAttributes
    .children()
    .map(function(index, elem) { return $(elem).attr('data-id'); })
    .toArray();

  return rowArray;
};

AnalysisController.prototype.getColumns = function() {
  var colArray = this.$columnAttributes
    .children()
    .map(function(index, elem) { return $(elem).attr('data-id'); })
    .toArray();

  return colArray;
};

AnalysisController.prototype.getFilters = function() {
  var unchecked = $(".pvtFilter:checkbox:not(:checked)");
  var filters = {};

  $.each(unchecked, function(key, filter) {
    var filterAttribute = $(filter).attr('data-attribute');
    var filterName = $(filter).siblings('span').text();

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
  var attribute = $('option:selected[name="attribute"]').val();
  aggregator.name = $('option:selected[name="aggregator"]').val();

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
