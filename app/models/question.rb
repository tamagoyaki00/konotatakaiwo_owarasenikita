class Question < ApplicationRecord
  belongs_to :user
  has_many :options, dependent: :destroy
  has_many :votes, through: :options
  has_many :opinions, dependent: :destroy


  validates :title, presence: true, length: { maximum: 29 }
  validates :user_id, presence: true

  scope :most_voted, -> {
    left_joins(:votes).group('questions.id').order('COUNT(votes.id) DESC')
  }

  scope :most_opinions, -> {
    left_joins(:opinions.)group('questions.id').order('COUNT(opinions.id)DESC')
  }

  scope :oldest, -> { order(created_at: :asc) }

  def total_votes
    votes.count
  end

  def editable?
    votes.empty? && opinions.empty?
  end

  def has_responses?
    votes.exists? || opinions.exists?
  end

end
