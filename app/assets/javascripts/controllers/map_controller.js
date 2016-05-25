MapController = function(config, locations) {
  this.$map = config.map;
  this.$locations = locations;

  this.getLocation();
};

MapController.prototype.getLocation = function() {
  var locationMap = {};

  $.map( this.$locations, function( location, index ) {
    var locationName = location[0];
    var locationCount = location[1];
    var geolocation = this.getCountryGeolocation(locationName);

    locationMap[locationName] = {
      center: geolocation,
      itemCount: locationCount
    }
  }.bind(this));

  this.initMap(locationMap);
}

MapController.prototype.getCountryGeolocation = function(country) {
  var geolocation = {};
  var url = 'https://maps.googleapis.com/maps/api/geocode/json?components=country:' + country + '&key=' + sonar.google_server_key;

  $.ajax({
    type: 'GET',
    dataType: 'json',
    url: url,
    async: false,
    success: function(response) {
      geolocation = response.results[0].geometry.location;
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });

  return geolocation;
};

MapController.prototype.initMap = function(locationMap) {
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 3,
    center: {lat: 37.090, lng: -95.712},
    mapTypeId: google.maps.MapTypeId.TERRAIN
  });

  $("a[href='#location']").on('shown.bs.tab', function(){
    google.maps.event.trigger(map, 'resize');
  });

  for (var location in locationMap) {
    var countryCircle = new google.maps.Circle({
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: map,
      center: locationMap[location].center,
      radius: Math.sqrt(locationMap[location].itemCount) * 100000
    });
  }
};
