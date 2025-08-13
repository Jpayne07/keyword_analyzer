import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box"]
  static values = { brand: String }

  connect() {
    // On frame load, re-check boxes based on what's in the store
    const store = document.getElementById("selected-store")
    if (!store) return

    this.boxTargets.forEach(cb => {
      const name = cb.dataset.name
      const selector = `input[type="hidden"][name="selected_categories[${this.brandValue}][]"][value="${cssEscape(name)}"]`
      cb.checked = !!store.querySelector(selector)
    })
  }

toggle(event) {
  const cb = event.target
  const store = document.querySelector("#selected-store")
  if (!store) return

  const name = cb.dataset.name
  const brand = this.brandValue
  const inputName = `selected_categories[${brand}][]`

  // Remove existing if unchecked
  const existing = store.querySelector(
    `input[name="${inputName}"][value="${name}"]`
  )
  if (!cb.checked) {
    if (existing) existing.remove()
    return
  }

  // Add if missing
  if (!existing) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = inputName
    input.value = name
    store.appendChild(input)
  }
}


}

// Minimal cssEscape so values with spaces/specials work in querySelector
function cssEscape(s) {
  return String(s).replace(/["\\]/g, "\\$&")
}
