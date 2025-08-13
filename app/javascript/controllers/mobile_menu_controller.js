import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button", "icon"]
  
  connect() {
    this.outsideClickHandler = this.closeOnOutsideClick.bind(this)
  }
  
  disconnect() {
    document.removeEventListener('click', this.outsideClickHandler)
  }
  
  toggle() {
    this.menuTarget.classList.toggle('hidden')
    this.updateIcon()
    
    if (!this.menuTarget.classList.contains('hidden')) {
      setTimeout(() => {
        document.addEventListener('click', this.outsideClickHandler)
      }, 0)
    } else {
      document.removeEventListener('click', this.outsideClickHandler)
    }
  }
  
  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
  
  close() {
    this.menuTarget.classList.add('hidden')
    this.updateIcon()
    document.removeEventListener('click', this.outsideClickHandler)
  }
  
  updateIcon() {
    const isHidden = this.menuTarget.classList.contains('hidden')
    if (isHidden) {
      this.iconTarget.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>'
    } else {
      this.iconTarget.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>'
    }
  }
}
