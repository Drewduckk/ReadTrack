class Book < ApplicationRecord
  has_paper_trail

  has_many :reading_assignments, dependent: :destroy

  validates :title, presence: true
  validates :author, presence: true
  validates :content, presence: true
  validates :lines_per_page, numericality: { only_integer: true, greater_than: 0 }

  # Teilt den Buchtext in echte Seiten auf (je lines_per_page Zeilen).
  # Wird gecached, da der Text sich waehrend eines Requests nicht aendert.
  def pages
    @pages ||= content.to_s.split("\n", -1).each_slice(lines_per_page).map { |lines| lines.join("\n") }
  end

  def page_count
    pages.size
  end

  # Text einer einzelnen Seite (1-indiziert). Ausserhalb des gueltigen
  # Bereichs wird nil zurueckgegeben, statt einen Fehler zu werfen.
  def page(number)
    return nil if number.nil? || number < 1

    pages[number - 1]
  end
end