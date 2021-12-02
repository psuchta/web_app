import { Controller } from "@hotwired/stimulus"
import { MarkerClusterer } from "@googlemaps/markerclusterer";


export default class extends Controller {
  static targets = ['map', 'field', 'latitude', 'longtitude']
  static values = {
      addresses: Array
    }

  connect() {
    if (typeof google != "undefined") {
      this.initMap();
    }
  }

  showAllAddresses() {
    if(this._map !== undefined) return this._map

   this.addressesValue = this.addressesValue.map((position)=> {
    position.lat = parseFloat(position.lat);
    position.lng = parseFloat(position.lng);
    return position;
   })

   const locations = this.addressesValue.filter(({lat, lng}) => {
    return lat || lng;
   });

    this._map = new google.maps.Map(this.mapTarget, {
      center: new google.maps.LatLng(
        52.5,
        19.35
      ),
      zoom: 6,
    });
  
    const infoWindow = new google.maps.InfoWindow();

    const markers = locations.map(({address, description, ...position}, i) => {
      const marker = new google.maps.Marker({
        position
      });
      const contentString = this.addressInfoWindow(address, description);

      marker.addListener("click", () => {
        infoWindow.setContent(contentString);
        infoWindow.open(this._map, marker);
      });
      return marker;
    });

    // Add a marker clusterer to manage the markers.
    new MarkerClusterer({ markers: markers, map: this._map });
  }

  initMap() {
    const init_latitude = this.data.get('latitude')
    const init_longtitude = this.data.get('longtitude')

    if(this._map !== undefined) return this._map

    if (init_latitude && init_longtitude){
      this.init_for_edit(init_latitude, init_longtitude);
    }
    else {
      this.init_blank_map();
    }
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget);
    this.autocomplete.bindTo('bounds', this._map);
    this.autocomplete.setFields(['address_component', 'geometry', 'icon', 'name']);
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this));
    return this._map;
  }

  init_for_edit(latitude, longtitude) {
    const myLatLong= new google.maps.LatLng(latitude,longtitude);

    this._map = new google.maps.Map(this.mapTarget, {
      center: myLatLong,
      zoom: 14,
    });

    this.marker = new google.maps.Marker({
      map: this._map,
      anchorPoint: new google.maps.Point(52, 19)
    });

    // Set visible Marker
    this.marker.setPosition(myLatLong);
    this.marker.setVisible(true);
  }

  init_blank_map() {
    this._map = new google.maps.Map(this.mapTarget, {
      center: new google.maps.LatLng(
        52.5,
        19.35
      ),
      zoom: 6,
    });

    this.marker = new google.maps.Marker({
      map: this._map,
      anchorPoint: new google.maps.Point(52, 19)
    });
  }

  placeChanged() {
    let place = this.autocomplete.getPlace();

    if (!place.geometry) {
      window.alert(`No details available for: ${place.name}`);
      return;
    }

    if(place.geometry.viewport){
      this._map.fitBounds(place.geometry.viewport);
    } else {
      this._map.setCenter(place.geometry.location);
      this._map.setZoom(17);
    }

    this.marker.setPosition(place.geometry.location);
    this.marker.setVisible(true);

    this.latitudeTarget.value = place.geometry.location.lat();
    this.longtitudeTarget.value = place.geometry.location.lng();
  }

  keydown(event) {
    if (event.key == 'Enter') {
      event.preventDefault();
    }
  }

  addressInfoWindow(address, description) {
    const descriptionHtml  = description ? "<p> <b>Description: </b>" + description + "</p>" : '';
    return '<div id="content">' +
           '<div id="bodyContent">' +
           "<p> <b>Address: </b>" + address + "</p>"+
           descriptionHtml +
           "</div>" +
           "</div>";
  }
}
