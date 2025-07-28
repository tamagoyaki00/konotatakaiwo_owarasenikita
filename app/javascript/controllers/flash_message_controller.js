
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    setTimeout(() => {
      this.show()
    }, 10);


    this.timer = setTimeout(() => {
      this.hide()
    }, 10000); // 5秒後に消える (調整可能)
  }

  show() {
    this.containerTarget.classList.remove("translate-x-full", "opacity-0");
    this.containerTarget.classList.add("translate-x-0", "opacity-100");
    this.containerTarget.classList.remove("pointer-events-none");
    this.containerTarget.classList.add("pointer-events-auto");
  }

  hide() {
    clearTimeout(this.timer);
    this.containerTarget.classList.remove("translate-x-0", "opacity-100");
    this.containerTarget.classList.add("translate-x-full", "opacity-0");
    // pointer-events を none にして、非表示になった要素がクリックを妨げないようにする
    this.containerTarget.classList.remove("pointer-events-auto");
    this.containerTarget.classList.add("pointer-events-none");
  }

  // アニメーション終了後に要素をDOMから削除
  remove(event) {
    if (event.propertyName === 'transform' || event.propertyName === 'opacity') {
        this.element.remove();
    }
  }

  // disconnect はタイマーのクリーンアップに必要
  disconnect() {
    clearTimeout(this.timer);
  }
}