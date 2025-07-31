class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :option

  validates :user_id, presence: true
  validates :option_id, presence: true
end
