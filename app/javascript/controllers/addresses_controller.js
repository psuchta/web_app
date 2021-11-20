import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['map', 'field', 'latitude', 'longtitude']

  connect() {
    if (typeof google != "undefined") {
      this.initMap();
    }
  }

  initMap() {
    if (this._map === undefined) {
      this._map = new google.maps.Map(this.mapTarget, {
        center: new google.maps.LatLng(
          39.5,
          -98.35
        ),
        zoom: 4,
      });
      this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget);
      this.autocomplete.bindTo('bounds', this._map);
      this.autocomplete.setFields(['address_component', 'geometry', 'icon', 'name']);
      this.autocomplete.addListener('place_changed', this.placeChanged.bind(this));
    }
    this.marker = new google.maps.Marker({
      map: this._map,
      anchorPoint: new google.maps.Point(0, -29)
    });

    return this._map;
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
}
