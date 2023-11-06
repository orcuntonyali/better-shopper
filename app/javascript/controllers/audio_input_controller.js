import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["transcribedText", "recordButton", "textAreaFrame", "submitButton"];

  connect() {
    console.log("Stimulus controller connected");
    this.isRecording = false;
    this.mediaRecorder = null;
    this.audioChunks = [];
    this.loadTextAreaContent();

    navigator.mediaDevices.getUserMedia({ audio: true })
      .then(stream => {
        this.mediaRecorder = new MediaRecorder(stream);
        this.mediaRecorder.ondataavailable = this.handleDataAvailable.bind(this);
        this.mediaRecorder.onstop = this.handleStop.bind(this);
      })
      .catch(err => console.error("Error initializing media recorder:", err));
  }

  loadTextAreaContent() {
    const savedText = localStorage.getItem('transcribedText');
    if (savedText) {
      this.showTextArea(savedText);
    }
  }

  toggleRecording() {
    if (!this.isInitialized) {
      this.initializeTextArea();
      return; // Early return to avoid starting recording immediately
    }

    if (!this.isRecording) {
      this.startRecording();
    } else {
      this.stopRecording();
    }
  }

  startRecording() {
    if (this.mediaRecorder.state === "inactive") {
      console.log("Start recording triggered");
      this.audioChunks = [];
      this.mediaRecorder.start();
      this.isRecording = true; // Set the recording state to true

      const recordText = this.recordButtonTarget.querySelector('.record-text');
      if (recordText) {
        recordText.textContent = "Recording...";
        this.recordButtonTarget.classList.remove("violet");
        this.recordButtonTarget.classList.add("gray");
      } else {
        console.error('The record-text element does not exist!');
      }
    }
  }

  stopRecording() {
    if (this.mediaRecorder && this.mediaRecorder.state === "recording") {
      this.mediaRecorder.stop();
      this.isRecording = false; // Set the recording state to false

      const recordText = this.recordButtonTarget.querySelector('.record-text');
      if (recordText) {
        recordText.textContent = "Tap to Speak";
        this.recordButtonTarget.classList.remove("gray");
        this.recordButtonTarget.classList.add("violet");
      } else {
        console.error('The record-text element does not exist!');
      }
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

  initializeTextArea() {
    this.hideQuickTips();
    this.showTextArea();

    // Hide 'TAP TO START' button
    const tapToStartButton = this.element.querySelector('[data-action="click->audio-input#initializeTextArea"]');
    tapToStartButton.classList.add('hidden');

    // Reveal and initialize the record button for recording actions
    this.recordButtonTarget.classList.remove('hidden');

    const recordText = this.recordButtonTarget.querySelector('.record-text');
    if (recordText) {
      recordText.textContent = "Tap to Speak";
    } else {
      console.error('The record-text element does not exist!');
    }
    this.isInitialized = true;
  }

  showTextArea(newText = '') {
    const quickTips = "Quick Tips:\n1. Speak or Type\n2. Edit\n3. Press 'Find groceries'";

    // Check if newText is an event object and reset it if so
    if (typeof newText === 'object') {
      newText = '';
    }

    let textarea = this.textAreaFrameTarget.querySelector('.transcribed-text');

    if (!textarea) {
      // If textarea doesn't exist, create it and set the placeholder
      textarea = document.createElement('textarea');
      textarea.className = 'transcribed-text h--100';
      textarea.id = 'transcribedText';
      textarea.setAttribute('data-audio-input-target', 'transcribedText');
      textarea.placeholder = quickTips; // Set the placeholder text
      this.textAreaFrameTarget.appendChild(textarea);
    }

    // If there's newText, add it to the textarea and show the submit button
    if (newText) {
      textarea.value = newText; // Set new text if provided
      this.submitButtonTarget.classList.remove('hidden');
    } else {
      // If there's saved text in localStorage, use it, otherwise show placeholder
      const savedText = localStorage.getItem('transcribedText');
      textarea.value = savedText ? savedText : '';
      this.submitButtonTarget.classList.toggle('hidden', !savedText);
    }

    // Update localStorage when textarea content changes
    textarea.addEventListener('input', () => {
      const textValue = textarea.value;
      this.submitButtonTarget.classList.toggle('hidden', !textValue.trim()); // Hide submit button if textarea is empty
      localStorage.setItem('transcribedText', textValue);
    });
  }

  hideQuickTips() {
    const quickTips = this.element.querySelector('.quick-tips');
    if (quickTips) {
      quickTips.classList.add('hidden');
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
      if (data.processed_order && Array.isArray(data.processed_order)) {
        // Redirect to cart item creation page, assuming you store processed_order in the session or send it through params
        window.location.href = "/cart_items/my_cart";
      } else {
        console.log('Error processing items.');
      }
    })
    .catch(error => {
      console.log("Order processing failed:", error);
    });
  }

}
