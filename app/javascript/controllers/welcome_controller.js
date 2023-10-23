import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["message", "messageContent", "notice"]

  connect() {
    if (this.data.get("userSignedIn") === "true") {
      this.messageContentTarget.textContent = `Welcome back, ${this.data.get("username")}!`
    }
  }
}
