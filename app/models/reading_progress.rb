class ReadingProgress < ApplicationRecord
  has_paper_trail

  belongs_to :student, class_name: "User"
  belongs_to :reading_assignment

  validates :current_page, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :student_id, uniqueness: { scope: :reading_assignment_id, message: "has already recorded progress for this assignment" }
end
