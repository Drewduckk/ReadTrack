class CreateReadingAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_assignments do |t|
      t.references :book, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.integer :released_until

      t.timestamps
    end
  end
end
