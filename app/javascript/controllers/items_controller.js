import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "item", "checkbox"]

  // Called when the controller is connected to the DOM
  connect() {
    this.allowSingleSelection();
  }

  // Change the image when a data attribute is set
  changeImage() {
    this.imageTarget.src = this.data.get("image-url");
  }

  // Handle selection of checkboxes
  selectOption(event) {
    const checkbox = event.currentTarget;
    if (checkbox.checked) {
      this.deselectOtherOptions(checkbox);
      const optionIndex = this.checkboxTargets.indexOf(checkbox);
      this.toggleOptionSelection(optionIndex, true);
    }
  }

  // Deselect other checkboxes except the first one
  deselectOtherOptions(selectedCheckbox) {
    this.checkboxTargets.forEach((cb, index) => {
      if (cb !== selectedCheckbox) {
        cb.checked = false;
        this.toggleOptionSelection(index, false);
      }
    });
  }

  // Apply single selection logic
  allowSingleSelection() {
    this.checkboxTargets.forEach((checkbox, index) => {
      if (checkbox.checked && index !== 0) {
        checkbox.checked = false;
        this.toggleOptionSelection(index, false);
      }
    });
  }

  // Toggle the selected state for a purchase option
  toggleOptionSelection(optionIndex, selected) {
    this.checkboxTargets[optionIndex].checked = selected;
    this.element.querySelectorAll(".purchase-option").forEach((purchaseOption, index) => {
      if (index === optionIndex) {
        purchaseOption.classList.toggle("selected", selected);
      } else {
        purchaseOption.classList.remove("selected");
      }
    });
  }


}
