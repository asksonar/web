$(function(){
  if ($('#aircraft-index').length === 0) {
    return;
  }

  $('[data-submenu]').submenupicker();

  var datatableFilters = new DatatableFilters({
    newAircraftTemplate: $('#new-aircraft-template'),
    aircraftTable: $('.aircraft-table'),
    tableAircraftTable: $('.aircraft-table table'),
    filterContainer: $('.filter-container'),
    btnExportCsv: $('#btn-export-csv'),
    ctnDisplayCountSelect: $('#select-display-count'),
    displayCountSelect: $('#select-display-count a'),
    inputCheckbox: $('.filter input[type="checkbox"]'),
    filtersSelect: $('.selectpicker'),
    btnSaveChanges: $('#btn-save-changes')
  });

  var datatableView = new DatatableView({
    btnSaveView: $('#btn-save-view'),
    inputSaveView: $('#input-save-view'),
    divSavedViews: $('.saved-views'),
    deleteModal: $('#delete-with-ajax'),
    btnDeleteYes: $('#btn-delete-yes')
  }, datatableFilters);

  var datatableController = new DatatableController({
    filterCategory: $('.filter-category'),
    btnCollapseSidebar: $('.btn-collapse-sidebar i'),
    btnExpandSidebar: $('#btn-expand-sidebar'),
    mainWrapper: $('#main-wrapper'),
    mainContentHeader: $('.main-content-header')
  });
});
