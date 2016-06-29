$(function(){
  if ($('#fleets-index').length === 0) {
    return;
  }

  $('[data-submenu]').submenupicker();

  var datatableModal = new DatatableModal({
    btnSaveChanges: $('#btn-save-changes')
  });

  var datatableFilters = new DatatableFilters({
    newFleetTemplate: $('#new-fleet-template'),
    fleetTable: $('.fleet-table'),
    fleetTableBody: $('.fleet-table tbody'),
    filterContainer: $('.filter-container'),
    btnExportCsv: $('#btn-export-csv'),
    ctnDisplayCountSelect: $('#select-display-count'),
    displayCountSelect: $('#select-display-count a'),
    inputCheckbox: $('.filter input[type="checkbox"]'),
    filtersSelect: $('nav .selectpicker')
  });

  var datatableController = new DatatableController({
    btnEditMode: $('#btn-edit-mode'),
    btnEditColumn: $('.btn-edit-column'),
    btnMoveLeft: $('.btn-move-left'),
    btnMoveRight: $('.btn-move-right'),
    columnHeader: $('.column-header'),
    navSubContainer: $('.nav-sub-container'),
    btnCollapseSidebar: $('.btn-collapse-sidebar i'),
    btnExpandSidebar: $('#btn-expand-sidebar'),
    mainWrapper: $('#main-wrapper'),
    mainContentHeader: $('.main-content-header')
  });
});
