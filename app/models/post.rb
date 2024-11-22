class Post < ApplicationRecord
  belongs_to :user
  acts_as_votable
  # enum visibility: { visible: 0, private: 1 }
  VISIBILITIES = %w[public private].freeze
  validates :title, presence: true
  validates :content, presence: true
  validates :visibility, inclusion: { in: VISIBILITIES }

  scope :public_posts, -> { where(visibility: 'public') }
  scope :private_posts, -> { where(visibility: 'private') }
end
