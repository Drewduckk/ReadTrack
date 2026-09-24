# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_23_140001) do
  create_table "books", force: :cascade do |t|
    t.string "author"
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "lines_per_page", default: 80, null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "reading_assignments", force: :cascade do |t|
    t.integer "book_id", null: false
    t.datetime "created_at", null: false
    t.integer "released_until"
    t.integer "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reading_assignments_on_book_id"
    t.index ["teacher_id"], name: "index_reading_assignments_on_teacher_id"
  end

  create_table "reading_progresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_page", default: 0, null: false
    t.integer "reading_assignment_id", null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["reading_assignment_id"], name: "index_reading_progresses_on_reading_assignment_id"
    t.index ["student_id", "reading_assignment_id"], name: "idx_on_student_id_reading_assignment_id_3952b7c214", unique: true
    t.index ["student_id"], name: "index_reading_progresses_on_student_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "summaries", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "page_from"
    t.integer "page_to"
    t.integer "reading_assignment_id", null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["reading_assignment_id"], name: "index_summaries_on_reading_assignment_id"
    t.index ["student_id"], name: "index_summaries_on_student_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address"
    t.string "email_change"
    t.string "email_change_token"
    t.string "name"
    t.string "password_digest"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["email_change_token"], name: "index_users_on_email_change_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.text "object", limit: 1073741823
    t.text "object_changes", limit: 1073741823
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "reading_assignments", "books"
  add_foreign_key "reading_assignments", "users", column: "teacher_id"
  add_foreign_key "reading_progresses", "reading_assignments"
  add_foreign_key "reading_progresses", "users", column: "student_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "summaries", "reading_assignments"
  add_foreign_key "summaries", "users", column: "student_id"
end
