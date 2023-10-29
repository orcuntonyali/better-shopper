import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    this.allowSingleSelection();
  }

  // Handle click on the table-view div
  toggleCheckbox(event) {
    const clickedDiv = event.currentTarget;
    const checkbox = clickedDiv.querySelector('input[type="checkbox"]');
    checkbox.checked = !checkbox.checked;
    this.selectOption({ currentTarget: checkbox });
  }

  // Handle selection of checkboxes
  selectOption(event) {
    const checkbox = event.currentTarget;
    if (checkbox.checked) {
      this.deselectOtherOptions(checkbox);
    } else {
      // Re-check the checkbox because at least one checkbox should always be checked
      checkbox.checked = true;
    }
  }

  // Deselect other checkboxes except the currently clicked one
  deselectOtherOptions(selectedCheckbox) {
    this.checkboxTargets.forEach((cb) => {
      if (cb !== selectedCheckbox) {
        cb.checked = false;
      }
    });
  }

  // Ensure that only the first checkbox is selected initially
  allowSingleSelection() {
    this.checkboxTargets.forEach((checkbox, index) => {
      checkbox.checked = index === 0;
    });
  }
}
