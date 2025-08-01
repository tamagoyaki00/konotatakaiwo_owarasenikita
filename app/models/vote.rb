class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :option

  validates :user_id, presence: true
  validates :option_id, presence: true
  validates :user_id, uniqueness: { scope: :option_id }
  validate :user_can_only_vote_once_per_question, on: :create

  private

  def user_can_only_vote_once_per_question
    if user && option && user.votes.joins(:option).exists?(options: { question_id: option.question_id })
    errors.add(:base, "このお題は既に解答済みです")
    end
  end
end
