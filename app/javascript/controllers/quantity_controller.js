import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["display"];

  increment() {
    this.updateQuantity(1);
  }

  decrement() {
    this.updateQuantity(-1);
  }

  updateQuantity(change) {
    let quantity = parseInt(this.displayTarget.innerText) + change;
    if (quantity > 0) {
      this.displayTarget.innerText = quantity;
      document.getElementById('quantityInput').value = quantity; // Update the hidden field
      document.getElementById('updateCartForm').submit(); // Automatically submit the form after updating the quantity
    }
  }
}
