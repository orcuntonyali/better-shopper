import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
export default class extends Controller {
  static targets  = ["map", "hidden"]
  static outlets = ["buttons"]
  static values = {
    apiKey: String,
    markers: Array
  }
  connect() {
    console.log(this.element)
    this.inputAddress = null;
    console.log(this.element.dataset)
    this.userLatitude = parseFloat(this.element.dataset.userLatitude);
    this.userLongitude = parseFloat(this.element.dataset.userLongitude);
    this.updateAddress = null;
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [this.userLongitude, this.userLatitude],
      zoom: 12
    })
    this.#addMarkersToMap()
  }
  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);
      const color = marker.marker_color
      new mapboxgl.Marker({ color: color })
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map);
    });
  }
  showMapboxSearchBox() {
    this.buttonsOutlet.changeAddressTarget.classList.add("d-none")
    this.buttonsOutlet.lookingGoodTarget.classList.add("d-none")
    if (!document.querySelector('.mapboxgl-ctrl-geocoder--input')) {
    const geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl
    });
    this.map.addControl(geocoder);
    geocoder.on('result', (e) => {
      const address = e.result.place_name;
      this.updateAddress = address;
      this.buttonsOutlet.setNewAddressTarget.classList.remove("d-none")
    });
  }
  }
  send(e){
    this.hiddenTarget.value = this.updateAddress
  }
}
