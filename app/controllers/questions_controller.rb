class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_question, only: %i[ show edit update destroy ]
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
    @question_form = QuestionForm.new(question: @question)
  end

  def update
    @question_form = QuestionForm.new(question: @question, params: question_form_params)
    if @qustion_form.save
      notice = "更新しました"
    else
      notice = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy

    redirect_to root_path
  end

  private

  def question_form_params
    params.require(:question).permit(:title, :option1_content, :option2_content)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
