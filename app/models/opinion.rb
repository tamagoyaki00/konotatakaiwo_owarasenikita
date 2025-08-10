class Opinion < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :opinion_reactions, dependent: :destroy

  validates :content, presence: true, length: { maximum: 250 }
  validates :user_id, presence: true
  validates :question_id, presence: true
end
