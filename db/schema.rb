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

ActiveRecord::Schema[7.0].define(version: 2023_03_31_142058) do
  create_table "issues", force: :cascade do |t|
    t.string "subject", null: false
    t.text "description"
    t.integer "issue_type"
    t.integer "severity"
    t.integer "priority"
    t.integer "status"
    t.date "limitDate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.boolean "blocked", default: false
    t.index ["project_id"], name: "index_issues_on_project_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_memberships_on_project_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_tags_on_issue_id"
  end

  create_table "timeline_events", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message", default: ""
    t.index ["issue_id"], name: "index_timeline_events_on_issue_id"
    t.index ["user_id"], name: "index_timeline_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "bio", default: ""
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "watched_issues", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_watched_issues_on_issue_id"
    t.index ["user_id"], name: "index_watched_issues_on_user_id"
  end

  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users"
  add_foreign_key "memberships", "projects"
  add_foreign_key "memberships", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "tags", "issues"
  add_foreign_key "timeline_events", "issues"
  add_foreign_key "timeline_events", "users"
  add_foreign_key "watched_issues", "issues"
  add_foreign_key "watched_issues", "users"
end
