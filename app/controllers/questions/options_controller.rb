class Questions::OptionsController < ApplicationController
  before_action :set_question only: %i[edit update destroy]
  before_action :set_option
  def new
    @question_form = QuestionForm.new(user_id: current_user.id)
  end

  def create
    @question_form = QuestionForm.new(params: question_form_params.merge(user_id: current_user.id))
    @option.save
    end
  end

  def edit
  end

  def update
  end

  def destroy
     @option.destroy
     redirect_to @question, notice: "選択肢が削除されました"
  end

  private

  def option_params
    params.require(:option).permit(:content)
  end

  def set_question
    @question = Question.find(params[:question_id])
    rescue ActiveRecord::RecordNotFound
    redirect_to questions_path, alert: '指定された質問が見つかりませんでした。'
  end

  def set_option
    @option = @question.options.find(params[:id])
  end
end
