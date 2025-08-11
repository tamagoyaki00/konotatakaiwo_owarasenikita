class OpinionReactionsController < ApplicationController
  def create
    @opinion = Opinion.find(params[:opinion_id])
    @reactions = @opinion.opinion_reactions.create!(user: current_user)
  end

  def destroy
    @opinion_reaction = OpinionReaction.find(params[:id])
    @opinion = @opinion_reaction.opinion
    @opinion_reaction.destroy!
  end
end
