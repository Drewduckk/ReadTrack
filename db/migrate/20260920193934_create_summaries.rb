class CreateSummaries < ActiveRecord::Migration[8.1]
  def change
    create_table :summaries do |t|
      t.references :student, null: false, foreign_key: true
      t.references :reading_assignment, null: false, foreign_key: true
      t.integer :page_from
      t.integer :page_to
      t.text :content

      t.timestamps
    end
  end
end
