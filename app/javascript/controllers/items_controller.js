import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    this.allowSingleSelection();
  }

  toggleCheckbox(event) {
    const clickedDiv = event.currentTarget;
    const checkbox = clickedDiv.querySelector('input[type="checkbox"]');
    checkbox.checked = !checkbox.checked;
    this.selectOption({ currentTarget: checkbox, clickedDiv: clickedDiv });
  }

  selectOption(event) {
    const checkbox = event.currentTarget;
    const clickedDiv = event.clickedDiv;
    if (checkbox.checked) {
      this.deselectOtherOptions(checkbox);
      clickedDiv.classList.add("selected");
    } else {
      checkbox.checked = true; // Re-check because one checkbox should always be selected
      clickedDiv.classList.remove("selected");
    }
  }

  deselectOtherOptions(selectedCheckbox) {
    this.checkboxTargets.forEach((cb) => {
      if (cb !== selectedCheckbox) {
        cb.checked = false;
        cb.parentElement.parentElement.classList.remove("selected"); // Remove the "selected" class from the parent .table-view div
      }
    });
  }

  allowSingleSelection() {
    this.checkboxTargets.forEach((checkbox, index) => {
      checkbox.checked = index === 0;
      if (index === 0) {
        checkbox.parentElement.parentElement.classList.add("selected"); // Add the "selected" class to the first .table-view div
      }
    });
  }

  confirmSelection(event) {
    const selectedOptionIndex = event.currentTarget.getAttribute("data-selected-option-index");
    const itemPath = event.currentTarget.getAttribute("data-items-url");
    const redirectPath = `/cart_items/display_cart_items?selected_option_index=${selectedOptionIndex}`;

    window.location.href = redirectPath;
  }
}
