require "test_helper"

class BookTest < ActiveSupport::TestCase
  def setup
    @book = books(:one)
  end

  test "valid book saves" do
    book = Book.new(title: "Test", author: "Author", content: "Content")
    assert book.valid?
    assert book.save
  end

  test "book invalid without title" do
    book = Book.new(author: "Author", content: "Content")
    assert_not book.valid?
    assert book.errors[:title].present?
  end

  test "pages splits content into chunks of lines_per_page lines" do
    book = Book.new(
      title: "Long Book",
      author: "Author",
      lines_per_page: 2,
      content: "Zeile 1\nZeile 2\nZeile 3\nZeile 4\nZeile 5"
    )
    assert_equal 3, book.page_count
    assert_equal "Zeile 1\nZeile 2", book.page(1)
    assert_equal "Zeile 3\nZeile 4", book.page(2)
    assert_equal "Zeile 5", book.page(3)
  end

  test "page returns nil for out-of-range page numbers" do
    book = Book.new(title: "Short", author: "Author", content: "Nur eine Seite", lines_per_page: 80)
    assert_nil book.page(0)
    assert_nil book.page(99)
    assert_equal "Nur eine Seite", book.page(1)
  end

  test "book invalid with lines_per_page of zero" do
    book = Book.new(title: "T", author: "A", content: "C", lines_per_page: 0)
    assert_not book.valid?
    assert book.errors[:lines_per_page].present?
  end
end
