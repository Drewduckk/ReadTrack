class Book < ApplicationRecord
  has_paper_trail

  has_many :reading_assignments, dependent: :destroy

  validates :title, presence: true
  validates :author, presence: true
  validates :content, presence: true

  # Returns only the portion of content up to the given page number.
  # Assumes approximately CHARS_PER_PAGE characters per page.
  CHARS_PER_PAGE = 500

  def content_until(page)
    return content if page.nil? || content.blank?

    char_limit = page * CHARS_PER_PAGE
    return content if content.length <= char_limit

    # Truncate at char_limit but cut cleanly at a word boundary
    truncated = content[0, char_limit]
    last_space = truncated.rindex(/\s/)
    last_space ? truncated[0, last_space] : truncated
  end
end