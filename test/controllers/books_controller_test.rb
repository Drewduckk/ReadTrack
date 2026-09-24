require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher)
    @student = users(:student_one)
    @book = books(:one)
  end

  test "authenticated users can list books" do
    sign_in_as(@student)
    get books_url
    assert_response :success
  end

  test "authenticated users can view book" do
    sign_in_as(@student)
    get book_url(@book)
    assert_response :success
  end

  test "teacher can create book" do
    sign_in_as(@teacher)
    assert_difference("Book.count", 1) do
      post books_url, params: {
        book: {
          title: "Neues Buch",
          author: "Ein Autor",
          content: "Inhalt des neuen Buches."
        }
      }
    end
    assert_redirected_to book_url(Book.last)
  end

  test "student cannot create book" do
    sign_in_as(@student)
    assert_no_difference("Book.count") do
      post books_url, params: {
        book: {
          title: "Verbotenes Buch",
          author: "Schueler",
          content: "Text"
        }
      }
    end
    assert_redirected_to root_url
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "teacher can update book" do
    sign_in_as(@teacher)
    patch book_url(@book), params: { book: { title: "Geänderter Titel" } }
    assert_redirected_to book_url(@book)
    assert_equal "Geänderter Titel", @book.reload.title
  end

  test "student cannot update book" do
    sign_in_as(@student)
    patch book_url(@book), params: { book: { title: "Hack Titel" } }
    assert_redirected_to root_url
    assert_not_equal "Hack Titel", @book.reload.title
  end
end
