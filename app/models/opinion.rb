class Opinion < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :opinion_reactions, dependent: :destroy
  has_many :liked_users, through: :opinion_reactions, source: :user

  validates :content, presence: true, length: { maximum: 250 }
  validates :user_id, presence: true
  validates :question_id, presence: true
end
