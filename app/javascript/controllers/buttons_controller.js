import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["address"];
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

    // Redirect to the items_path
    confirmSelection() {
      window.location.href = "<%= items_path %>";
    }
}
