class Summary < ApplicationRecord
  has_paper_trail

  belongs_to :student, class_name: "User"
  belongs_to :reading_assignment

  validates :content, presence: true
  validates :page_from, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :page_to, presence: true, numericality: { greater_than_or_equal_to: 1 }

  validate :page_numbers_order
  validate :pages_within_released_range

  private

  def page_numbers_order
    return unless page_from.present? && page_to.present?

    if page_to < page_from
      errors.add(:page_to, "muss grösser oder gleich 'Seite von' sein")
    end
  end

  def pages_within_released_range
    return unless reading_assignment && page_to.present?

    if page_to > reading_assignment.released_until
      errors.add(:page_to, "kann nicht über den freigegebenen Bereich (bis Seite #{reading_assignment.released_until}) hinausgehen")
    end
  end
end