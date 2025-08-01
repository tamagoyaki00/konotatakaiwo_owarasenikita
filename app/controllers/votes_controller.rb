class VotesController < ApplicationController
  before_action :set_question, only: [:create]

  def create
    puts "--- VotesController#create START ---"
    puts "DEBUG: params: #{params.inspect}"
    puts "DEBUG: @question (after set_question): #{@question.inspect}" # set_question後の@questionの状態

    option = Option.find_by(id: vote_params[:option_id])
    puts "DEBUG: option found: #{option.inspect}"

    # 無効な選択肢の場合の処理
    unless option && option.question_id == @question.id
      puts "DEBUG: Invalid option or option does not belong to question."
      respond_to do |format|
        format.html { redirect_back_or_to(@question, alert: '無効な選択肢です。') }
        format.turbo_stream { flash.now[:alert] = '無効な選択肢です。' }
      end
      puts "--- VotesController#create END (Invalid Option Path) ---"
      return
    end

    @vote = current_user.votes.build(option: option)
    puts "DEBUG: @vote built: #{@vote.inspect}"

    respond_to do |format|
      if @vote.save
        puts "DEBUG: Vote saved successfully."
        flash.now[:notice] = '投票が完了しました！'
        format.html { redirect_to @question, notice: '投票が完了しました！' }
        format.turbo_stream { puts "DEBUG: Rendering turbo_stream for success." }
      else
        puts "DEBUG: Vote save failed. Errors: #{@vote.errors.full_messages.inspect}"
        flash.now[:alert] = @vote.errors.full_messages.join(', ')
        format.html { redirect_to @question, alert: @vote.errors.full_messages.join(', ') }
        format.turbo_stream { puts "DEBUG: Rendering turbo_stream for failure." }
      end
    end
    puts "--- VotesController#create END ---"
  end

  def destroy
    @vote = current_user.votes.find_by(id: params[:id])

    unless @vote
      respond_to do |format|
        format.html { redirect_back_or_to(root_path, alert: '投票が見つからないか、削除する権限がありません。') }
        format.turbo_stream { flash.now[:alert] = '投票が見つからないか、削除する権限がありません。' }
      end
      return
    end
    @question = @vote.option.question

    respond_to do |format|
      if @vote.destroy
        flash.now[:notice] = '投票を取り消しました。'
        format.html { redirect_to @question, notice: '投票を取り消しました。' }
        format.turbo_stream
      else
        flash.now[:alert] = '投票の取り消しに失敗しました。'
        format.html { redirect_to @question, alert: '投票の取り消しに失敗しました。' }
        format.turbo_stream
      end
    end
  end
  

  private

  def set_question
    puts "--- set_question START ---"
    puts "DEBUG: params[:question_id] in set_question: #{params[:question_id].inspect}"
    @question = Question.find(params[:question_id])
    puts "DEBUG: @question set in set_question: #{@question.inspect}"
  rescue ActiveRecord::RecordNotFound => e
    puts "DEBUG: ActiveRecord::RecordNotFound in set_question: #{e.message}"
    redirect_to root_path, alert: 'お題が見つかりませんでした。'
  end

  def vote_params
    params.require(:vote).permit(:option_id)
  end
end
