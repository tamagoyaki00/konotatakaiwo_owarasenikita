class Option < ApplicationRecord
    belongs_to :question
    has_many :votes, dependent: :destroy

    validates :content, presence: true, length: { maximum: 29 }
    validates :question_id, presence: true

    def votes_count
      votes.count
    end

    def percentage_of_question_votes
      total_question_votes = question.total_votes
      return 0.0 if total_question_votes.zero?
      (votes_count.to_f / total_question_votes) * 100
    end
end
