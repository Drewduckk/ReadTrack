# "foreign_key: true" auf :teacher/:student leitet die Zieltabelle vom
# Referenznamen ab (teachers/students) - es gibt aber nur eine "users"
# Tabelle (siehe belongs_to :teacher, class_name: "User"). Bei aktivierten
# SQLite Foreign Keys wuerde das jeden INSERT in reading_assignments bzw.
# summaries verhindern.
class FixTeacherAndStudentForeignKeys < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :reading_assignments, :teachers
    add_foreign_key :reading_assignments, :users, column: :teacher_id

    remove_foreign_key :summaries, :students
    add_foreign_key :summaries, :users, column: :student_id
  end
end
