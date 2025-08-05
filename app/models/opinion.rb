class Opinion < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :option, optional: true

  validates :content, presence: true, length: { maximum: 250 }
end
