class BooksController < ApplicationController
  before_action :require_authentication
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = policy_scope(Book)
    authorize Book
  end

  def show
    authorize @book
  end

  def new
    @book = Book.new
    authorize @book
  end

  def create
    @book = Book.new(book_params)
    authorize @book

    if @book.save
      redirect_to @book, notice: "Buch wurde erfolgreich erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @book
  end

  def update
    authorize @book

    if @book.update(book_params)
      redirect_to @book, notice: "Buch wurde erfolgreich aktualisiert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @book
    @book.destroy
    redirect_to books_path, notice: "Buch wurde gelöscht."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :content, :lines_per_page)
  end
end
