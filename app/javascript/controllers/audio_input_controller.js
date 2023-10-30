import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["transcribedText", "recordButton"];

  connect() {
    console.log("Stimulus controller connected");
    this.isRecording = false;
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

  toggleRecording() {
    this.isRecording = !this.isRecording;
    this.isRecording ? this.startRecording() : this.stopRecording();
  }

  startRecording() {
    console.log("Start recording triggered");
    this.audioChunks = [];
    this.mediaRecorder.start();

    // Toggle visibility of icons and text
    this.recordButtonTarget.querySelector('.record-icon').classList.add('hidden');
    this.recordButtonTarget.querySelector('.stop-icon').classList.remove('hidden');
    this.recordButtonTarget.querySelector('.record-text').classList.add('hidden');
    this.recordButtonTarget.querySelector('.stop-text').classList.remove('hidden');

    // Change button color
    this.recordButtonTarget.classList.remove("violet");
    this.recordButtonTarget.classList.add("gray");
  }

  stopRecording() {
    this.mediaRecorder.stop();

    // Toggle visibility back
    this.recordButtonTarget.querySelector('.record-icon').classList.remove('hidden');
    this.recordButtonTarget.querySelector('.stop-icon').classList.add('hidden');
    this.recordButtonTarget.querySelector('.record-text').classList.remove('hidden');
    this.recordButtonTarget.querySelector('.stop-text').classList.add('hidden');

    // Change button color back
    this.recordButtonTarget.classList.remove("gray");
    this.recordButtonTarget.classList.add("violet");
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
      console.log("Received data:", data);
      if (data.status === "success") {
        this.showTextArea(data.transcribed_text);  // Pass the transcribed text here
      }
    })
    .catch(error => {
      console.log("Audio upload failed:", error);
    });
  }

  showTextArea(preExistingText = '') {
    // Check if preExistingText is an object (PointerEvent, in this case)
    if (typeof preExistingText === 'object') {
      preExistingText = '';
    }

    let frame = document.getElementById('textAreaFrame');
    let textarea = frame.querySelector('.transcribed-text');

    // If textarea doesn't exist, create it
    if (!textarea) {
      textarea = document.createElement('textarea');
      textarea.className = 'transcribed-text';
      textarea.id = 'transcribedText';
      textarea.setAttribute('data-audio-input-target', 'transcribedText');
      frame.appendChild(textarea);
    }

    // Update textarea value and display it
    textarea.value = preExistingText;
    textarea.style.display = 'block';
    textarea.classList.add('show');
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
      if (data.processed_order && Array.isArray(data.processed_order)) {
        // Redirect to cart item creation page, assuming you store processed_order in the session or send it through params
        window.location.href = "/cart_items/display_cart_items";
      } else {
        console.log('Error processing items.');
      }
    })
    .catch(error => {
      console.log("Order processing failed:", error);
    });
  }

}
