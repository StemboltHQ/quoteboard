# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160423231847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favourites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "quote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "favourites", ["quote_id"], name: "index_favourites_on_quote_id", using: :btree
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "full_name"
    t.string   "slack_name"
    t.boolean  "employee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.string   "quoted_person"
    t.text     "body"
    t.string   "location"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  add_index "quotes", ["user_id"], name: "index_quotes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "value"
    t.integer  "user_id"
    t.integer  "quote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "votes", ["quote_id"], name: "index_votes_on_quote_id", using: :btree
  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree

  add_foreign_key "favourites", "quotes"
  add_foreign_key "favourites", "users"
  add_foreign_key "quotes", "users"
  add_foreign_key "votes", "quotes"
  add_foreign_key "votes", "users"
end
