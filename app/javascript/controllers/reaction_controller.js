import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]
  
  connect() {
    console.log("🎉 Reaction controller connected!")
    this.debugElement()
  }
  
  debugElement() {
    const icon = this.iconTarget
    if (icon) {
      console.log("🔍 Element debug info:")
      console.log("- Element:", icon)
      console.log("- Classes:", icon.className)
      console.log("- Computed style:", window.getComputedStyle(icon))
      console.log("- Parent element:", icon.parentElement)
      console.log("- Element visible:", icon.offsetWidth > 0 && icon.offsetHeight > 0)
      console.log("- Position:", icon.getBoundingClientRect())
    }
  }
  
  animate(event) {
    console.log("🚀 Button clicked!")
    this.testAllAnimations()
  }
  
  testAllAnimations() {
    const icon = this.iconTarget
    if (!icon) {
      console.log("❌ Icon target not found!")
      return
    }
    
    console.log("🧪 Testing all animations...")
    
    // 1. Font Awesomeアニメーション
    this.testFontAwesomeAnimation()
    
    // 2. CSS Transformアニメーション
    setTimeout(() => this.testCSSTransform(), 2000)
    
    // 3. Web Animations APIアニメーション
    setTimeout(() => this.testWebAnimationsAPI(), 4000)
    
    // 4. 強制的なスタイル変更
    setTimeout(() => this.testDirectStyle(), 6000)
  }
  
  testFontAwesomeAnimation() {
    console.log("🧪 Testing Font Awesome animation...")
    const icon = this.iconTarget
    
    icon.classList.remove('fa-bounce')
    icon.offsetHeight
    
    setTimeout(() => {
      icon.classList.add('fa-bounce')
      console.log("✅ fa-bounce added")
      console.log("📊 Current classes:", icon.className)
      console.log("📊 Computed animation:", window.getComputedStyle(icon).animation)
      
      setTimeout(() => {
        icon.classList.remove('fa-bounce')
        console.log("🏁 fa-bounce removed")
      }, 1500)
    }, 100)
  }
  
  testCSSTransform() {
    console.log("🧪 Testing CSS Transform...")
    const icon = this.iconTarget
    
    icon.style.transition = 'transform 0.5s ease-in-out'
    icon.style.transform = 'scale(1.5) rotate(360deg)'
    console.log("✅ CSS Transform applied")
    
    setTimeout(() => {
      icon.style.transform = 'scale(1) rotate(0deg)'
      console.log("🏁 CSS Transform reset")
      
      setTimeout(() => {
        icon.style.transition = ''
        icon.style.transform = ''
      }, 500)
    }, 1000)
  }
  
  testWebAnimationsAPI() {
    console.log("🧪 Testing Web Animations API...")
    const icon = this.iconTarget
    
    const animation = icon.animate([
      { transform: 'scale(1) rotate(0deg)', color: 'currentColor' },
      { transform: 'scale(1.3) rotate(180deg)', color: '#ff6b6b' },
      { transform: 'scale(1.5) rotate(360deg)', color: '#4ecdc4' },
      { transform: 'scale(1) rotate(0deg)', color: 'currentColor' }
    ], {
      duration: 1000,
      easing: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)'
    })
    
    console.log("✅ Web Animations API started")
    
    animation.onfinish = () => {
      console.log("🏁 Web Animations API finished")
    }
  }
  
  testDirectStyle() {
    console.log("🧪 Testing Direct Style Manipulation...")
    const icon = this.iconTarget
    
    let scale = 1
    let rotation = 0
    const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#f7b731']
    let colorIndex = 0
    
    const interval = setInterval(() => {
      scale = scale === 1 ? 1.4 : 1
      rotation += 45
      
      icon.style.transform = `scale(${scale}) rotate(${rotation}deg)`
      icon.style.color = colors[colorIndex % colors.length]
      icon.style.transition = 'all 0.3s ease-in-out'
      
      colorIndex++
      console.log(`✅ Direct style applied: scale(${scale}) rotate(${rotation}deg)`)
      
      if (colorIndex >= 8) {
        clearInterval(interval)
        setTimeout(() => {
          icon.style.transform = ''
          icon.style.color = ''
          icon.style.transition = ''
          console.log("🏁 Direct style reset")
        }, 300)
      }
    }, 400)
  }
}