class OpinionsController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @opinion = @question.opinions.build(opinion_params)
    @opinion.user = current_user
    
    respond_to do |format|
        if @opinion.save
            @opinions = @question.opinions.includes(:user).order(created_at: :desc)
            format.turbo_stream
        else
          @opinions = @question.opinions.includes(:user).order(created_at: :desc)
          format.turbo_stream { render :create, status: :unprocessable_entity }  # エラー時
        end
    end
   end

  def destroy
    @opinion = current_user.opinions.find(params[:id])
    @opinion.destroy
  end

  private

  def opinion_params
    params.require(:opinion).permit(:content)
  end
end
