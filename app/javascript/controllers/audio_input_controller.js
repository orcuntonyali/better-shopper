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
    this.updateInstruction();
    this.isRecording ? this.startRecording() : this.stopRecording();
  }

  startRecording() {
    console.log("Start recording triggered");
    this.audioChunks = [];
    this.mediaRecorder.start();
    this.recordButtonTarget.classList.remove("fa-microphone");
    this.recordButtonTarget.classList.add("fa-stop");
  }

  stopRecording() {
    this.mediaRecorder.stop();
    this.recordButtonTarget.classList.remove("fa-stop");
    this.recordButtonTarget.classList.add("fa-microphone");
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

  updateInstruction() {
    let frame = document.getElementById('instructionFrame');
    let newInstruction = this.isRecording ? "Tap when you're done speaking" : "Tap to speak your grocery";
    frame.innerHTML = `<h1>${newInstruction}</h1>`;
  }

  showTextArea() {
    let frame = document.getElementById('textAreaFrame');
    frame.innerHTML = '<textarea class="transcribed-text" data-audio-input-target="transcribedText" id="transcribedText"></textarea>';
    let textarea = frame.querySelector('.transcribed-text');
    setTimeout(() => { textarea.classList.add('show'); }, 0);
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
