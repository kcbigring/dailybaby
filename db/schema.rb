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

ActiveRecord::Schema.define(version: 20140109191547) do

  create_table "addresses", force: true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id"

  create_table "albums", force: true do |t|
    t.integer  "smugmug_id"
    t.string   "key"
    t.string   "nice_name"
    t.string   "title"
    t.string   "url"
    t.integer  "kid_id"
    t.string   "password"
    t.string   "custom_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "children", force: true do |t|
    t.integer  "user_id"
    t.integer  "kid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "children", ["user_id"], name: "index_children_on_user_id"

  create_table "phones", force: true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["user_id"], name: "index_phones_on_user_id"

  create_table "recipients", force: true do |t|
    t.integer  "user_id"
    t.integer  "delivery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipients", ["user_id"], name: "index_recipients_on_user_id"

  create_table "scheduled_emails", force: true do |t|
    t.integer  "parent_id"
    t.integer  "kid_id"
    t.boolean  "delivered",  default: false
    t.string   "image_id"
    t.string   "image_key"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scheduled_emails", ["kid_id"], name: "index_scheduled_emails_on_kid_id"
  add_index "scheduled_emails", ["parent_id"], name: "index_scheduled_emails_on_parent_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.date     "birthdate"
    t.string   "sex"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "cell_phone"
    t.integer  "reminder_delivery_preference", default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
