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
    // Start with the user's location
    let coordinatesArray = [[this.userLongitude, this.userLatitude]];

    // Add each store's coordinates to the array
    this.markersValue.forEach((marker) => {
      coordinatesArray.push([marker.lng, marker.lat]);
    });

    // Construct the URL for the Mapbox API call
    let url = `https://api.mapbox.com/directions/v5/mapbox/driving/${coordinatesArray.join(';')}?geometries=geojson&access_token=${this.apiKeyValue}`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        console.log(data);
        const routes = data.routes[0];

        // Calculate the total distance of the route
        const totalDistanceInKilometers = routes.distance / 1000;
        document.querySelector('#total-distance').innerText = `${totalDistanceInKilometers.toFixed(2)} km`;

        // Update distances for individual stores if needed here

        // Add the complete route to the map
        const routeCoordinates = routes.geometry;
        if (!this.map.getSource('route')) {
          this.map.addSource('route', {
            type: 'geojson',
            data: routeCoordinates
          });

          this.map.addLayer({
            id: 'route',
            type: 'line',
            source: 'route',
            layout: {},
            paint: {
              'line-color': '#3867d6',
              'line-width': 5
            }
          });
        } else {
          this.map.getSource('route').setData(routeCoordinates);
        }
      })
      .catch(error => console.error('Error fetching directions:', error));
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
    const user_marker_color = '#6200ee'
    const store_marker_color = 'gray'


    const storesData = this.element.dataset.stores;
    const stores = JSON.parse(storesData || '[]');

    // Ensure that we have user location data before adding markers
    if (!isNaN(userLatitude) && !isNaN(userLongitude)) {
      // Add a marker for user location
      new mapboxgl.Marker({ color: user_marker_color })
        .setLngLat([userLongitude, userLatitude])
        .setPopup(popup)
        .addTo(this.map);
    }

    // Add markers for nearby stores if available
    stores.forEach((store) => {
      const popup = new mapboxgl.Popup().setHTML(store.info_window_html);
      new mapboxgl.Marker({ color: store_marker_color })
        .setLngLat([store.lng, store.lat])
        .setPopup(popup)
        .addTo(this.map);
    });
  }
}
