import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
export default class extends Controller {
  static targets  = ["map", "hidden", "distance"]
  static outlets = ["buttons"]
  static values = {
    apiKey: String,
    markers: Array,
    showDirections: Boolean
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
    this.#fitMapToMarkers()

    this.addUserLocationAndNearbyStoresToMap();
    if (this.hasShowDirectionsValue) {
      this.#showDirections()

    }
  }
  #showDirections() {
    let url = "https://api.mapbox.com/directions/v5/mapbox/driving/"
    url += this.userLongitude
    url += ","
    url += this.userLatitude
    url += ";"
    this.markersValue.forEach((marker) => {
      url += marker.lng
      url += ","
      url += marker.lat
      url += ";"
    })
    url = url.substring(0, url.length - 1)  // remove last semicolon
    url += "?geometries=geojson&access_token="
    url += this.apiKeyValue
    console.log(url)
    fetch(url)
  .then(response => response.json())
  .then(data => {
    console.log(data)
    this.distanceTarget.innerText = data.routes[0].distance/1000
    // Get the route geometry coordinates from the API response
    const routeCoordinates = data.routes[0].geometry;

    // Format the route coordinates as a GeoJSON LineString feature
    const lineString = {
      type: 'Feature',
      geometry: routeCoordinates
    };
    console.log(lineString)
    // Add the line to the map
    this.map.addLayer({
      id: 'route',
      type: 'line',
      source: {
        type: 'geojson',
        data: lineString
      },
      paint: {
        'line-color': '#3867d6',
        'line-width': 3
      }
    });
  });
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
  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    bounds.extend([ this.userLongitude, this.userLatitude])
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
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
  addUserLocationAndNearbyStoresToMap() {

    const userLatitude = parseFloat(this.element.dataset.userLatitude);
    const userLongitude = parseFloat(this.element.dataset.userLongitude);


    const storesData = this.element.dataset.stores;
    const stores = JSON.parse(storesData || '[]');

    // Ensure that we have user location data before adding markers
    if (!isNaN(userLatitude) && !isNaN(userLongitude)) {
      // Add a marker for user location
      new mapboxgl.Marker({ color: 'blue' })
        .setLngLat([userLongitude, userLatitude])
        .addTo(this.map);
    }

    // Add markers for nearby stores if available
    stores.forEach((store) => {
      const popup = new mapboxgl.Popup().setHTML(store.info_window_html);
      new mapboxgl.Marker({ color: store.marker_color })
        .setLngLat([store.lng, store.lat])
        .setPopup(popup)
        .addTo(this.map);
    });
  }
}
