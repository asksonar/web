$(function(){
  if ($('#fleets-index').length === 0) {
    return;
  }

  $('[data-submenu]').submenupicker();

  var datatableFilters = new DatatableFilters({
    newFleetTemplate: $('#new-fleet-template'),
    fleetTable: $('.fleet-table'),
    tablefleetTable: $('.fleet-table table'),
    filterContainer: $('.filter-container'),
    btnExportCsv: $('#btn-export-csv'),
    ctnDisplayCountSelect: $('#select-display-count'),
    displayCountSelect: $('#select-display-count a'),
    inputCheckbox: $('.filter input[type="checkbox"]'),
    filtersSelect: $('nav .selectpicker'),
    btnSaveChanges: $('#btn-save-changes')
  });

  var datatableView = new DatatableView({
    btnSaveView: $('#btn-save-view'),
    inputSaveView: $('#input-save-view'),
    divSavedViews: $('.saved-views')
  }, datatableFilters);

  var datatableController = new DatatableController({
    navSubContainer: $('.nav-sub-container'),
    btnCollapseSidebar: $('.btn-collapse-sidebar i'),
    btnExpandSidebar: $('#btn-expand-sidebar'),
    mainWrapper: $('#main-wrapper'),
    mainContentHeader: $('.main-content-header')
  });
});
