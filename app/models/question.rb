class Question < ApplicationRecord
  
  belongs_to :user
  has_many :options, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100}
  validates :user_id, presence: true
end
