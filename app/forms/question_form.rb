class QuestionForm
  include ActiveModel::Model

  attr_accessor :title, :user_id
  attr_accessor :option1_content, :option2_content

  validates :title, presence: true, length: { maximum: 29 }
  validates :option1_content, presence: true, length: { maximum: 29 }
  validates :option2_content, presence: true, length: { maximum: 29 }
  validates :user_id, presence: { message: "ログインしてください" }
  validate :options_must_be_unique

  def initialize(question: nil, attributes: {})
    @question = question || Question.new

    if attributes.present?
      assign_attributes(attributes)
    elsif @question.persisted?
      load_from_question
    end
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      save_question!
      save_options!
    end
    true
  rescue ActiveRecord::RecordInvalid => e # バリデーションエラーなどで例外が発生した場合
    e.record.errors.each do |error|
      errors.add(error.attribute, error.message)
    end
    Rails.logger.error "QuestionForm save failed: #{e.message}"
    false
  rescue => e # その他の予期せぬエラー
    Rails.logger.error "QuestionForm save encountered an unexpected error: #{e.message}"
    errors.add(:base, "お題の保存中に予期せぬエラーが発生しました。")
    false
  end

  # フォームヘルパーがモデルのように振る舞えるようにするための定義
  # form_with model: @question_form, url: questions_path が正しく動作するために必要

  # レコードのキーを返す (通常はid)
  def to_key
    @question.to_key
  end

  # URLヘルパーのために必要 (例: question_path(@question_form))
  def to_param
    @question.to_param
  end

  # 既存のデータがあるか
  def persisted?
    @question.persisted?
  end

  # フォームオブジェクトを'question'という名前のモデルとして扱わせる
  # これにより、フォームのパラメータ名が params[:question_form] ではなく params[:question] となる
  # これは form_with model: @question_form, scope: :question と同じ効果がある
  def model_name
    ActiveModel::Name.new(self.class, nil, "Question")
  end

  def question
    @question
  end

  private

  def load_from_question
    self.title = @question.title
    self.user_id = @question.user_id
    @question.options.each_with_index do |option, i|
      send("option#{i+1}_content=", option.content)
    end
  end


  def save_question!
    @question.title = title
    @question.user_id = user_id
    @question.save!
  end

  def save_options!
    @question.options.destroy_all if @question.persisted?

    @question.options.create!(content: option1_content)
    @question.options.create!(content: option2_content)
  end

  def options_must_be_unique
    if option1_content.present? && option2_content.present? && option1_content == option2_content
      errors.add(:base, "選択肢は重複しないようにしてください")
    end
  end
end
