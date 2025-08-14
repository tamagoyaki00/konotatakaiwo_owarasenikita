import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    percentage: Number,
    duration: Number 
  }
  
  connect() {
    setTimeout(() => {
      this.animateProgress()
    }, 50)
  }
  
  animateProgress() {
    this.element.style.width = '0%'
    this.element.style.transition = `width ${this.durationValue || 1500}ms ease-out`
    
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.style.width = `${this.percentageValue}%`
      })
    })
  }
}