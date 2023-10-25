import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["address", "maxDistance"];
  static values = {
    mapController: String
  }
  connect() {
    this.element.addEventListener("click", (event) => {
      event.preventDefault();
       });
  }
  changeAddress() {
    // const searchbox = document.querySelector(".search-box");
    // searchbox.style.display = "block";
    const changeAddressButton = this.element.querySelector(".change-address-button");
    changeAddressButton.style.display = "none";
    const userAddress = document.querySelector(".user-details");
    userAddress.style.display = "none";
    const mapController = this.application.getControllerForElementAndIdentifier(
      document.getElementById('map'),
      "map"
    );
    if (mapController) {
      mapController.showMapboxSearchBox();
    }
  }
  lookingGood() {
    if (confirm("Proceed to cart_items/new?")) {
      window.location.href = "/cart_items/new";
    }
  }
  confirmSelection() {
    window.location.href = "<%= items_path %>";
  }
  setMaxDistance() {
    const maxDistanceValue = this.maxDistanceTarget.value;
    if (maxDistanceValue === "") {
      // Handle empty value if needed
      alert("Please provide a max distance value");
      return;
    }

    // Make an AJAX request to send the maxDistanceValue to the server
    fetch('/set_max_distance', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getMetaContent('csrf-token') // Assuming you've defined a helper to get the CSRF token
      },
      body: JSON.stringify({ max_distance: maxDistanceValue })
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === 'success') {
        // Handle successful update of max distance
        alert("Max distance has been updated.");
      } else {
        // Handle failure to update max distance
        alert("An error occurred. Could not update max distance.");
      }
    })
    .catch(error => {
      // Handle any other errors
      console.error('Error:', error);
    });
    function getMetaContent(name) {
      const element = document.head.querySelector(`meta[name="${name}"]`);
      return element ? element.content : null;
    }
  }
}
