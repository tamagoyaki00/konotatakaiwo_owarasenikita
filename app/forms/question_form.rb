class QuestionForm
  include ActiveModel::Model

  attr_accessor :title, :user_id
  attr_accessor :option1_content, :option2_content

  validates :title, presence: true, length: { maximum: 29 }
  validates :option1_content, presence: true, length: { maximum: 29 }
  validates :option2_content, presence: true, length: { maximum: 29 }
  validates :user_id, presence: { message: "ログインしてください" }

  def initialize(question: nil, params: {})
    @question = question || Question.new # 既存のQuestionがなければ新規作成

    if params.present? # フォームからのパラメータがある場合
      self.title = params[:title]
      self.user_id = params[:user_id]
      self.option1_content = params[:option1_content]
      self.option2_content = params[:option2_content]
    elsif @question.persisted? # 既存のQuestionを編集する場合（パラメータがない場合）
      self.title = @question.title
      self.user_id = @question.user_id
      # 既存の選択肢の内容をフォームオブジェクトの属性に設定
      @question.options.each_with_index do |option, i|
        # option1_content, option2_content にセット
        send("option#{i+1}_content=", option.content)
      end
    end
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @question.title = title
      @question.user_id = user_id
      @question.save!

      # 既存の選択肢があれば更新、なければ新規作成
      option1 = @question.options[0] || @question.options.build
      option1.content = option1_content
      option1.save!

      option2 = @question.options[1] || @question.options.build
      option2.content = option2_content
      option2.save!
    end
    true
  rescue ActiveRecord::RecordInvalid => e # バリデーションエラーなどで例外が発生した場合
    Rails.logger.error "QuestionForm save failed: #{e.message}"
    false
  rescue => e # その他の予期せぬエラー
    Rails.logger.error "QuestionForm save encountered an unexpected error: #{e.message}"
    false
  end

  # フォームヘルパーがモデルのように振る舞えるようにするための定義
  # form_with model: @question_form, url: questions_path のように書くため

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
end
