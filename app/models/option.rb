class Option < ApplicationRecord
    belongs_to :question

    validates :content, presence: true, length: { maximum: 50 }
    validates :question_id, presence: true
end
