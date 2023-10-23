// app/javascript/controllers/item_details_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "item", "checkbox"]

  connect() {

  }

  changeImage() {
    this.imageTarget.src = this.data.get("image-url");
  }

  changeItem() {
    this.itemTarget.textContent = this.data.get("item-name");
  }

  selectOption(event) {
    const checkbox = event.currentTarget;
    const purchaseOption = checkbox.closest(".purchase-option");

    if (checkbox.checked) {
      purchaseOption.classList.add("selected");
    } else {
      purchaseOption.classList.remove("selected");
    }
  }
}

