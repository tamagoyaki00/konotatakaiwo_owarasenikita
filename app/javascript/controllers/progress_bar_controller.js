
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    percentage: Number,
    duration: Number 
  }
  
  connect() {
    // 少し遅延を入れてアニメーションを開始
    setTimeout(() => {
      this.animateProgress()
    }, 50)
  }
  
  animateProgress() {
    // 初期状態を設定
    this.element.style.width = '0%'
    this.element.style.transition = `width ${this.durationValue || 1500}ms ease-out`
    
    // アニメーション開始
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.style.width = `${this.percentageValue}%`
      })
    })
  }
}