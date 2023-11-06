import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["display"];

  increment(event) {
    event.preventDefault();
    this.updateQuantity(event, 1);
  }

  decrement(event) {
    event.preventDefault();
    this.updateQuantity(event, -1);
  }

  async updateQuantity(event, change) {
    const csrfToken = document.querySelector("meta[name=csrf-token]").content;
    const quantity = parseInt(this.displayTarget.innerText) + change;
    if (quantity > 0) {
      const action = event.currentTarget.action;
      try {
        const response = await fetch(`/${action.split("/").slice(3).join("/")}`, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': csrfToken,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ change: change })
        });
        const data = await response.json();
        if(data.status == "success") this.displayTarget.innerText = quantity;
      } catch (error) {
        console.log(error);
      }
    }
  }
}
