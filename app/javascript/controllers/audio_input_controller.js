import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["transcribedText"];
  connect() {
    console.log("Stimulus controller connected");
    this.mediaRecorder = null;
    this.audioChunks = [];

    navigator.mediaDevices.getUserMedia({ audio: true })
      .then(stream => {
        this.mediaRecorder = new MediaRecorder(stream);
        this.mediaRecorder.ondataavailable = this.handleDataAvailable.bind(this);
        this.mediaRecorder.onstop = this.handleStop.bind(this);
      })
      .catch(err => console.error("Error initializing media recorder:", err));
  }

  startRecording() {
    console.log("Start recording triggered");
    this.audioChunks = [];
    this.mediaRecorder.start();
    this.element.querySelector("[data-action='click->audio-input#stopRecording']").disabled = false;
  }

  stopRecording() {
    this.mediaRecorder.stop();
    this.element.querySelector("[data-action='click->audio-input#stopRecording']").disabled = true;
  }

  handleDataAvailable(event) {
    this.audioChunks.push(event.data);
  }

  handleStop() {
    const audioBlob = new Blob(this.audioChunks, { type: "audio/wav" });
    this.uploadAudio(audioBlob);
  }

  uploadAudio(audioBlob) {
    const formData = new FormData();
    formData.append("audio_file", audioBlob, "user_audio.wav");
    fetch("/cart_items/process_audio", {
      method: "POST",
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === "success") {
        this.transcribedTextTarget.value = data.transcribed_text;
      }
    })
    .catch(error => {
      console.log("Audio upload failed:", error);
    });
  }

  submitReviewedText() {
    const reviewedText = this.transcribedTextTarget.value;
    fetch("/cart_items/process_order", {
      method: "POST",
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ order_input: reviewedText })
    })
    .then(response => response.json())
    .then(data => {
      console.log("Returned data from server:", data);
      const itemList = document.querySelector('#cart-items-list');
      itemList.innerHTML = ''; // Clear the current list

      // Check if 'processed_order' exists and is an array
      if (data.processed_order && Array.isArray(data.processed_order)) {
        data.processed_order.forEach(item => {
          const listItem = document.createElement('li');
          listItem.textContent = `Item: ${item.name}, Quantity: ${item.quantity}`;
          itemList.appendChild(listItem);
        });
      } else {
        const errorItem = document.createElement('li');
        errorItem.textContent = 'Error processing items.';
        itemList.appendChild(errorItem);
      }
    })
    .catch(error => {
      console.log("Order processing failed:", error);
    });
  }
}
