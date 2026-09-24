class CreateReadingProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_progresses do |t|
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :reading_assignment, null: false, foreign_key: true
      t.integer :current_page, default: 0, null: false

      t.timestamps
    end

    add_index :reading_progresses, [:student_id, :reading_assignment_id], unique: true
  end
end
