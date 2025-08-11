import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "icon" ]

  bounce(event) {
    event.preventDefault();
    const link = event.currentTarget;
    
    this.iconTarget.classList.add("fa-bounce");

    setTimeout(() => {
      this.iconTarget.classList.remove("fa-bounce");
      link.click();
    }, 2000); // 1秒間バウンドアニメーションを実行
  }
}