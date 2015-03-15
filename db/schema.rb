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

ActiveRecord::Schema.define(version: 20140925081651) do

  create_table "admins", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nick_name",              default: "", null: false
    t.string   "role",                   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["nick_name"], name: "index_admins_on_nick_name", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "assets", force: true do |t|
    t.string   "avatar"
    t.string   "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_id"
  end

  create_table "conversations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friend_users", force: true do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.string  "status"
  end

  add_index "friend_users", ["user_id", "friend_id"], name: "index_friend_users_on_user_id_and_friend_id", unique: true, using: :btree

  create_table "group_users", force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.string  "status"
  end

  add_index "group_users", ["user_id", "group_id"], name: "index_group_users_on_user_id_and_group_id", unique: true, using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.boolean  "public"
    t.string   "avatar"
    t.integer  "user_id"
    t.text     "description"
    t.boolean  "always_on_top"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status",     default: "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conversation_id"
  end

  create_table "posts", force: true do |t|
    t.text     "message"
    t.boolean  "global",          default: false
    t.integer  "group_id"
    t.integer  "parent_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "profile_post_id"
  end

  add_index "posts", ["deleted_at"], name: "index_posts_on_deleted_at", using: :btree

  create_table "receipts", force: true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.boolean  "is_read",    default: false
    t.string   "mail_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nick_name",              default: "",     null: false
    t.string   "role",                   default: "user", null: false
    t.date     "birthday"
    t.string   "number",                 default: "",     null: false
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_activity"
    t.boolean  "online",                 default: false
    t.string   "language",               default: "ru"
    t.boolean  "show_status",            default: true
    t.boolean  "show_birthbay",          default: true
    t.boolean  "show_number",            default: true
    t.boolean  "invite_to_friend",       default: true
    t.boolean  "write_on_page",          default: true
    t.boolean  "show_image",             default: true
    t.boolean  "comment_post",           default: true
    t.boolean  "write_private_message",  default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["nick_name"], name: "index_users_on_nick_name", unique: true, using: :btree
  add_index "users", ["number"], name: "index_users_on_number", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
