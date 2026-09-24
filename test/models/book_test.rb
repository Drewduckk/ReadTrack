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

  test "content_until returns full content when page limit exceeds length" do
    # book content is short – page limit of 999 returns everything
    result = @book.content_until(999)
    assert_equal @book.content, result
  end

  test "content_until restricts content to released pages" do
    book = Book.new(
      title: "Long Book",
      author: "Author",
      content: "A" * 5000
    )
    # released_until: 2 → max 2 * 500 = 1000 chars
    result = book.content_until(2)
    assert result.length <= 1000
    assert result.length > 0
  end

  test "content_until returns all content when content is shorter than page limit" do
    book = Book.new(
      title: "Short Book",
      author: "Author",
      content: "Short content"
    )
    result = book.content_until(1)
    assert_equal "Short content", result
  end
end
