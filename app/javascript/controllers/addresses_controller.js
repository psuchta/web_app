import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['map', 'field', 'latitude', 'longtitude']

  connect() {
    if (typeof google != "undefined") {
      this.initMap();
    }
  }

  initMap() {
    const init_latitude = this.data.get('latitude')
    const init_longtitude = this.data.get('longtitude')

    if (this._map === undefined) {
      if (init_latitude && init_longtitude){
        const myLatLong= new google.maps.LatLng(init_latitude,init_longtitude);

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
      else {
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
      this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget);
      this.autocomplete.bindTo('bounds', this._map);
      this.autocomplete.setFields(['address_component', 'geometry', 'icon', 'name']);
      this.autocomplete.addListener('place_changed', this.placeChanged.bind(this));
    }
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
