# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170425101014) do

  create_table "attached_files", force: :cascade do |t|
    t.integer  "issue_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.index ["issue_id"], name: "index_attached_files_on_issue_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "issue_id"
    t.integer  "user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
<<<<<<< HEAD
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "kind",        default: "/images/issue_types/task.svg"
=======
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "kind",        default: 0
>>>>>>> 3263bc3510f61bfbbf468b0f6970a4c8bf9b219f
    t.integer  "user_id"
    t.integer  "priority",    default: 2
    t.string   "status",      default: "New"
  end

  create_table "table_votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "issue_id"
    t.index ["issue_id", "user_id"], name: "index_table_votes_on_issue_id_and_user_id", unique: true
    t.index ["issue_id"], name: "index_table_votes_on_issue_id"
    t.index ["user_id"], name: "index_table_votes_on_user_id"
  end

  create_table "table_watchers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "issue_id"
    t.index ["issue_id", "user_id"], name: "index_table_watchers_on_issue_id_and_user_id", unique: true
    t.index ["issue_id"], name: "index_table_watchers_on_issue_id"
    t.index ["user_id"], name: "index_table_watchers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "provider"
    t.string   "image_url"
    t.string   "nickname"
    t.integer  "issue_id"
  end

end
