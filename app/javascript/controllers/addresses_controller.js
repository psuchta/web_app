import { Controller } from '@hotwired/stimulus';
import { MarkerClusterer } from '@googlemaps/markerclusterer';

export default class extends Controller {
  static targets = ['map', 'field', 'latitude', 'longtitude'];

  static values = {
    addresses: Array,
  };

  connect() {
    if (typeof google !== 'undefined') {
      this.initMap();
    }
  }

  showAllAddresses() {
    const { google } = window;

    if (this.map !== undefined) return this.map;

    this.addressesValue = this.addressesValue.map((position) => {
      const newPosition = {};
      newPosition.lat = parseFloat(position.lat);
      newPosition.lng = parseFloat(position.lng);
      return newPosition;
    });

    const locations = this.addressesValue.filter(({ lat, lng }) => lat || lng);

    this.map = new google.maps.Map(this.mapTarget, {
      center: new google.maps.LatLng(
        52.5,
        19.35,
      ),
      zoom: 6,
    });

    const infoWindow = new google.maps.InfoWindow();

    const markers = locations.map(({ address, description, ...position }) => {
      const marker = new google.maps.Marker({
        position,
      });
      const contentString = this.addressInfoWindow(address, description);

      marker.addListener('click', () => {
        infoWindow.setContent(contentString);
        infoWindow.open(this.map, marker);
      });
      return marker;
    });

    // Add a marker clusterer to manage the markers.
    /* eslint-disable no-new */
    new MarkerClusterer({ markers, map: this.map });
    return this.map;
  }

  initMap() {
    const { google } = window;
    const initLatitude = this.data.get('latitude');
    const initLongtitude = this.data.get('longtitude');

    if (this.map !== undefined) return this.map;

    if (initLatitude && initLongtitude) {
      this.initForEdit(initLatitude, initLongtitude);
    } else {
      this.initBlankMap();
    }
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget);
    this.autocomplete.bindTo('bounds', this.map);
    this.autocomplete.setFields(['address_component', 'geometry', 'icon', 'name']);
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this));
    return this.map;
  }

  initForEdit(latitude, longtitude) {
    const { google } = window;
    const myLatLong = new google.maps.LatLng(latitude, longtitude);

    this.map = new google.maps.Map(this.mapTarget, {
      center: myLatLong,
      zoom: 14,
    });

    this.marker = new google.maps.Marker({
      map: this.map,
      anchorPoint: new google.maps.Point(52, 19),
    });

    // Set visible Marker
    this.marker.setPosition(myLatLong);
    this.marker.setVisible(true);
  }

  initBlankMap() {
    const { google } = window;
    this.map = new google.maps.Map(this.mapTarget, {
      center: new google.maps.LatLng(
        52.5,
        19.35,
      ),
      zoom: 6,
    });

    this.marker = new google.maps.Marker({
      map: this.map,
      anchorPoint: new google.maps.Point(52, 19),
    });
  }

  placeChanged() {
    const place = this.autocomplete.getPlace();

    if (!place.geometry) {
      window.alert(`No details available for: ${place.name}`);
      return;
    }

    if (place.geometry.viewport) {
      this.map.fitBounds(place.geometry.viewport);
    } else {
      this.map.setCenter(place.geometry.location);
      this.map.setZoom(17);
    }

    this.marker.setPosition(place.geometry.location);
    this.marker.setVisible(true);

    this.latitudeTarget.value = place.geometry.location.lat();
    this.longtitudeTarget.value = place.geometry.location.lng();
  }

  keydown(event) {
    if (event.key === 'Enter') {
      event.preventDefault();
    }
  }

  addressInfoWindow(address, description) {
    const descriptionHtml = description ? `<p> <b>Description: </b>${description}</p>` : '';
    return `${'<div id="content">'
           + '<div id="bodyContent">'
           + '<p> <b>Address: </b>'}${address}</p>${
      descriptionHtml
    }</div>`
           + '</div>';
  }
}
