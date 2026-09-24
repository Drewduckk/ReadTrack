class AddLinesPerPageToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :lines_per_page, :integer, default: 80, null: false
  end
end
