class Book < ApplicationRecord
  has_paper_trail

  has_many :reading_assignments, dependent: :destroy

  validates :title, presence: true
  validates :author, presence: true
  validates :content, presence: true
  validates :lines_per_page, numericality: { only_integer: true, greater_than: 0 }

  # Splits the book text into real pages (lines_per_page lines each).
  # Cached, since the text doesn't change during a request.
  def pages
    @pages ||= content.to_s.split("\n", -1).each_slice(lines_per_page).map { |lines| lines.join("\n") }
  end

  def page_count
    pages.size
  end

  # Text of a single page (1-indexed). Returns nil outside the valid
  # range instead of raising an error.
  def page(number)
    return nil if number.nil? || number < 1

    pages[number - 1]
  end
end