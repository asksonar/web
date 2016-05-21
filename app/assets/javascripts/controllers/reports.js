$(function(){
  if ($('#reports-index').length === 0) {
    return;
  }

  $('#btn-add-filter').on('click', function() {
    var sub_filter = $('#select-aircraft-type').val();
    var filters = { "aircraft_type": [sub_filter] };
    window.location.href = new URI(window.location.pathname).addSearch(filters);
  })

  if (aircraft_by_location) {    
    var mapController = new MapController({
      map: $('#map'),
    }, aircraft_by_location);
  }
});
