import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {}
  open(event) {
    
    const projectId = event.detail.fetchResponse?.response?.project_id || this.element.dataset.projectId
    const modal = document.getElementById("modal")
    if (modal) {
      modal.src = `/projects/modal?id=${projectId}`
      modal.classList.remove("hidden")
    }

    
  }
  close(e) {
    
    // Prevent default action
    e.preventDefault();
    // Remove from parent
    const modal = document.getElementById("modal");
    modal.innerHTML = "";

    // Remove the src attribute from the modal
    modal.removeAttribute("src");

    // Remove complete attribute
    modal.removeAttribute("complete");
  }
}