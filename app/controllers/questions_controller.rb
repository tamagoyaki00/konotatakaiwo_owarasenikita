class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_question, only: %i[ show edit update destroy ]
  before_action :check_user, only: %i[ edit update destroy ]

  def index
    @questions = Question.all.includes(:user).order(created_at: :desc)
  end

  def show
    @opinion =  Opinion.new
    @opinions = @question.opinions.includes(:user).order(created_at: :desc)
  end

  def new
    @question_form = QuestionForm.new(attributes: { user_id: current_user.id })
  end

  def create
    @question_form = QuestionForm.new(attributes: question_form_params.merge(user_id: current_user.id))

    if @question_form.save
      redirect_to @question_form.question, notice: "お題が作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @question.editable?
      redirect_to @question, alert: "回答や意見がある質問は編集できません"
      return
    end

    @question_form = QuestionForm.new(question: @question)
  end

  def update
    unless @question.editable?
      redirect_to @question, alert: "回答や意見がある質問は編集できません"
      return
    end
    @question_form = QuestionForm.new(question: @question, attributes: question_form_params.merge(user_id: current_user.id))
      if @question_form.save
        flash.now[:notice] = "お題が更新されました"
      else
        flash.now[:alert] = "お題の更新に失敗しました"
        render turbo_stream: turbo_stream.replace(
          "question_#{@question.id}",
          partial: "questions/form",
          locals: { question_form: @question_form }), status: :unprocessable_entity
      end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: "お題が削除されました", status: :see_other
  end

  private

  def question_form_params
    params.require(:question).permit(:title, :option1_content, :option2_content)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def check_user
    unless @question.user == current_user
      redirect_to root_path, alert: "権限がありません"
    end
  end
end
