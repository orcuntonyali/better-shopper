import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["quantity"];
  static classes = ["minusPlus"];

  increment() {
    this.quantityTarget.innerText = parseInt(this.quantityTarget.innerText) + 1;
  }

  decrement() {
    let currentQuantity = parseInt(this.quantityTarget.innerText);
    if (currentQuantity > 1) {
      this.quantityTarget.innerText = currentQuantity - 1;
    }
  }
}
