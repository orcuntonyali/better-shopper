import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }
  connect() {
    const userLatitude = parseFloat(this.element.dataset.userLatitude);
    const userLongitude = parseFloat(this.element.dataset.userLongitude);

    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/o-t-/clnxgq6xg008o01pf0kdy7vqk",
      center: [userLongitude, userLatitude],
      zoom: 12
    })
    this.#addMarkersToMap()
  }
  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);
      const color = marker.marker_color
      new mapboxgl.Marker({ color: color })
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map);
    });
  }
  showMapboxSearchBox() {
    this.map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl }));
  }
}
