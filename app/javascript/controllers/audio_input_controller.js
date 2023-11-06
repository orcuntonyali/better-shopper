import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["transcribedText", "recordButton", "submitButton"];

  connect() {
    console.log("Stimulus controller connected");
    this.isRecording = false;
    this.mediaRecorder = null;
    this.audioChunks = [];

    // Retrieve and set the textarea content from localStorage if available and not just whitespace
    const savedText = localStorage.getItem('transcribedText');
    if (savedText && savedText.trim().length > 0 && this.hasTranscribedTextTarget) {
      this.transcribedTextTarget.value = savedText.trim();
      this.submitButtonTarget.classList.remove('hidden');
    } else {
      localStorage.removeItem('transcribedText'); // Clear whitespace or empty strings
      this.submitButtonTarget.classList.add('hidden');
      this.transcribedTextTarget.value = "";
    }

    // Listen to changes in the textarea and update localStorage and button visibility
    if (this.hasTranscribedTextTarget) {
      this.transcribedTextTarget.addEventListener('input', () => {
        const textValue = this.transcribedTextTarget.value;
        if (textValue.trim().length > 0) {
          localStorage.setItem('transcribedText', textValue);
          this.submitButtonTarget.classList.remove('hidden');
        } else {
          localStorage.removeItem('transcribedText');
          this.submitButtonTarget.classList.add('hidden');
        }
      });
    }

    // Initialize media recorder
    navigator.mediaDevices.getUserMedia({ audio: true })
      .then(stream => {
        this.mediaRecorder = new MediaRecorder(stream);
        this.mediaRecorder.ondataavailable = this.handleDataAvailable.bind(this);
        this.mediaRecorder.onstop = this.handleStop.bind(this);
      })
      .catch(err => console.error("Error initializing media recorder:", err));
  }

  toggleRecording() {
    if (!this.isRecording) {
      this.startRecording();
    } else {
      this.stopRecording();
    }
  }

  startRecording() {
    if (this.mediaRecorder && this.mediaRecorder.state === "inactive") {
      this.mediaRecorder.start();
      this.isRecording = true; // Update recording state
      // Update UI for recording state
      this.recordButtonTarget.classList.add("gray");
      this.recordButtonTarget.querySelector('.record-icon').classList.add('active');
      this.recordButtonTarget.querySelector('.record-text').textContent = "Recording...";
    }
  }

  stopRecording() {
    if (this.mediaRecorder && this.mediaRecorder.state === "recording") {
      this.mediaRecorder.stop();
      this.isRecording = false; // Update recording state
      // Update UI for not recording state
      this.recordButtonTarget.classList.remove("gray");
      this.recordButtonTarget.querySelector('.record-icon').classList.remove('active');
      this.recordButtonTarget.querySelector('.record-text').textContent = "Tap to Speak";
    }
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
        this.showTextArea(data.transcribed_text);
      }
    })
    .catch(error => {
      console.log("Audio upload failed:", error);
    });
  }

  showTextArea(transcribedText) {
    if (this.hasTranscribedTextTarget) {
      this.transcribedTextTarget.value = transcribedText;
      this.submitButtonTarget.classList.remove('hidden');
      localStorage.setItem('transcribedText', transcribedText);
    }
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
      if (data.status === "success" && data.redirect_url) {
        window.location.href = data.redirect_url;
      } else {
        console.log('Error processing items:', data.message);
      }
    })
    .catch(error => {
      console.log("Order processing failed:", error);
    });
  }

}
