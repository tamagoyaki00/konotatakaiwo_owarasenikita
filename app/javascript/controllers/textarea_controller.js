import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "label", "counter", "currentLength"]
  static values = { maxLength: { type: Number, default: 50 } }

  connect() {
    this.updateCounter()
    this.checkInitialInput()
    this.inputTarget.addEventListener('input', this.input.bind(this));
    console.log("Textarea controller CONNECTED successfully!");
    console.log("Initial Max length value:", this.maxLengthValue);
  }


  input() {
    this.updateCounter()
    this.checkLabelPosition()
  }

  // 初期ロード時に入力があるかチェックし、ラベル位置を調整
  checkInitialInput() {
    if (this.inputTarget.value.length > 0) {
      this.labelTarget.classList.add('peer-not-placeholder-shown:top-1', 'peer-not-placeholder-shown:left-3', 'peer-not-placeholder-shown:text-xs', 'peer-not-placeholder-shown:text-blue-500');
    }
  }

  // 文字数カウンターを更新
  updateCounter() {
    const currentLength = this.inputTarget.value.length;
    this.currentLengthTarget.textContent = currentLength;
 console.log("Current length:", currentLength, "Max length:", this.maxLengthValue);
    // 文字数制限に応じて色を変更
    this.counterTarget.classList.remove('text-red-500', 'text-gray-500'); // 両方削除

    if (currentLength > this.maxLengthValue) {
      this.counterTarget.classList.add('text-red-500');   // 制限超過で赤色
    } else {
      this.counterTarget.classList.add('text-gray-500');   // 通常色
    }
  }


  checkLabelPosition() {
    if (this.inputTarget.value.length > 0) {
      this.labelTarget.classList.add('peer-not-placeholder-shown:top-1', 'peer-not-placeholder-shown:left-3', 'peer-not-placeholder-shown:text-xs', 'peer-not-placeholder-shown:text-blue-500');
    } else {
 
      this.labelTarget.classList.remove('peer-not-placeholder-shown:top-1', 'peer-not-placeholder-shown:left-3', 'peer-not-placeholder-shown:text-xs', 'peer-not-placeholder-shown:text-blue-500');
    }
  }
}