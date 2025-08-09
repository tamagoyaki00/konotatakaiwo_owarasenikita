class OpinionsController < ApplicationController
  before_action :set_opinion, only: %i[ edit update destroy]
  before_action :check_owner, only: %i[ edit update destroy]

  def create
    @question = Question.find(params[:question_id])
    @opinion = @question.opinions.build(opinion_params)
    @opinion.user = current_user

    if @opinion.save
      @opinions = @question.opinions.includes(:user).order(created_at: :desc)
    else
      @opinions = @question.opinions.includes(:user).order(created_at: :desc)
      render :create, status: :unprocessable_entity
    end
   end

  def edit
  end

  def update
    if @opinion.update(opinion_params)
      flash.now[:notice] = "意見が更新されました"
    else
      flash.now[:alert] = "意見の更新に失敗しました"
    end
  end

  def destroy
    @opinion.destroy
    flash.now[:notice] = "意見が削除されました"
  end

  private

  def set_opinion
    @opinion = Opinion.find(params[:id])
  end

  def check_owner
    unless current_user&.own?(@opinion)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("flash-messages",
            partial: "shared/flash_message",
            locals: { message: "権限がありません", type: "alert" })
        end
        format.html { redirect_to questions_path, alert: "権限がありません" }
      end
    end
  end

  def opinion_params
    params.require(:opinion).permit(:content)
  end
end
