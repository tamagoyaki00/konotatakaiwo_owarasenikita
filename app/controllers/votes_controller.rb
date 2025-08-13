class VotesController < ApplicationController
  before_action :set_question, only: [ :create ]

  def create
    option = Option.find_by(id: vote_params[:option_id])

    unless option && option.question_id == @question.id
      flash.now[:alert] = "無効な選択肢です"
      return
    end

    @vote = current_user.votes.build(option: option)

    if @vote.save
      flash.now[:notice] = "投票が完了しました"
    else
      flash.now[:alert] = @vote.errors.full_messages.join(", ")
    end
  end

  def destroy
    @vote = current_user.votes.find_by(id: params[:id])

    unless @vote
      flash.now[:alert] = "投票が見つからないか、削除する権限がありません"
      return
    end
    @question = @vote.option.question

    if @vote.destroy
      flash.now[:notice] = "投票を取り消しました"
    else
      flash.now[:alert] = "投票の取り消しに失敗しました"
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "お題が見つかりませんでした"
  end

  def vote_params
    params.require(:vote).permit(:option_id)
  end
end
