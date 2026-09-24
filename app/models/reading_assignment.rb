class ReadingAssignment < ApplicationRecord
  has_paper_trail

  belongs_to :book
  belongs_to :teacher, class_name: "User"

  has_many :summaries, dependent: :destroy
  has_many :reading_progresses, dependent: :destroy

  validates :released_until, presence: true
  validates :released_until, numericality: { greater_than: 0 }
end