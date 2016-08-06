$(function(){
  if ($('#analysis-index').length === 0) {
    return;
  }

  var defaults = {
    rowArray: ["Aircraft Model"],
    colArray: ["Aircraft Status"]
  }

  var pivotTable = new PivotTable({
    pivotContainer: $("#pivot-container"),
    btnSaveImg: $('#btn-save-img')
  }, defaults);

  var analysisController = new AnalysisController({
    renderersSelect: $('.selectpicker.renderers'),
    aggregatorsSelect: $('.selectpicker.aggregators'),
    attributesSelect: $('.selectpicker.attributes'),
    ctnSelectedAttributes: $('.ctn-selected-attributes'),
    rowAttributes: $('.ctn-selected-attributes #rows'),
    columnAttributes: $('.ctn-selected-attributes #columns'),
    btnUpdateFilter: $('.btn-update-filter'),
    btnSelectAll: $('.btn-select-all'),
    btnSelectNone: $('.btn-select-none'),
    inputFilter: $('.pvtSearch')
  }, pivotTable);

});
