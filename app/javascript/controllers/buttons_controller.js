import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["changeAddress", "lookingGood", "setNewAddress", "maxDistance", "toggle", "slider"];
  static values = {
    mapController: String
  }
  connect() {
    console.log("Buttons Controller connected")
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
          console.log(`Max Distance is: ${value}`);
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

  // delivery toggle button in orders/show
  connect() {
    this.toggleTarget.checked = false; // Initialize the toggle to OFF
    this.toggleTarget.addEventListener('change', this.toggleDelivery.bind(this));
    console.log("Controller connected to Orders/Show");
  }
  toggleDelivery() {
    const deliveryFee = 5;

    if (this.toggleTarget.checked) {
      this.sliderTarget.style.transform = 'translateX(0px)';
      // Delivery is ON
      console.log('Delivery is ON');

      // Show delivery fee
      document.querySelector('.delivery-fee').style.display = 'flex';

      // Update total with delivery fee
      const totalElement = document.querySelector('.total-price');
      const currentTotal = parseFloat(totalElement.innerText);
      totalElement.innerText = (currentTotal + deliveryFee).toFixed(2) + ' €';
    } else {
      this.sliderTarget.style.transform = 'translateX(0)';

      // Delivery is OFF
      console.log('Delivery is OFF');

      // Hide delivery fee
      document.querySelector('.delivery-fee').style.display = 'none';

      // Update total without delivery fee
      const totalElement = document.querySelector('.total-price');
      const currentTotal = parseFloat(totalElement.innerText);
      totalElement.innerText = (currentTotal - deliveryFee).toFixed(2) + ' €';
    }
  }
}
