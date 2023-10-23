import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["address"]

  changeAddress() {
    const userAddress = this.data.get("userAddress")
    this.addressTarget.textContent = userAddress
  }

  lookingGood() {
    // Add behavior for the "LOOKING GOOD" button here if needed.
  }
}
