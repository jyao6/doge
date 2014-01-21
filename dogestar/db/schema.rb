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

ActiveRecord::Schema.define(version: 20140121215317) do

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "to_id"
    t.integer  "from_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["from_id"], name: "index_messages_on_from_id", using: :btree
  add_index "messages", ["to_id"], name: "index_messages_on_to_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.integer  "sender_id"
    t.boolean  "cleared",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
  end

  add_index "notifications", ["sender_id"], name: "notifications_sender_id_fk", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "photos", force: true do |t|
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
  end

  add_index "photos", ["service_id"], name: "index_photos_on_service_id", using: :btree

  create_table "reset_passwords", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: true do |t|
    t.integer  "rating"
    t.text     "review"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
  end

  add_index "reviews", ["transaction_id"], name: "index_reviews_on_transaction_id", using: :btree

  create_table "services", force: true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "category"
    t.text     "description"
    t.boolean  "legitimized",                            default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cover_photo_id"
    t.decimal  "avg_rating",     precision: 4, scale: 2
  end

  add_index "services", ["category"], name: "index_services_on_category", using: :btree
  add_index "services", ["cover_photo_id"], name: "services_cover_photo_id_fk", using: :btree
  add_index "services", ["user_id"], name: "index_services_on_user_id", using: :btree

  create_table "transactions", force: true do |t|
    t.datetime "appt_time"
    t.decimal  "price",      precision: 10, scale: 2
    t.integer  "service_id"
    t.integer  "buyer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
  end

  add_index "transactions", ["buyer_id"], name: "index_transactions_on_buyer_id", using: :btree
  add_index "transactions", ["service_id"], name: "index_transactions_on_service_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "messages", "users", name: "messages_from_id_fk", column: "from_id"
  add_foreign_key "messages", "users", name: "messages_to_id_fk", column: "to_id"

  add_foreign_key "notifications", "users", name: "notifications_sender_id_fk", column: "sender_id"
  add_foreign_key "notifications", "users", name: "notifications_user_id_fk"

  add_foreign_key "photos", "services", name: "photos_service_id_fk"

  add_foreign_key "reviews", "transactions", name: "reviews_transaction_id_fk"

  add_foreign_key "services", "photos", name: "services_cover_photo_id_fk", column: "cover_photo_id"
  add_foreign_key "services", "users", name: "services_user_id_fk"

  add_foreign_key "transactions", "services", name: "transactions_service_id_fk"
  add_foreign_key "transactions", "users", name: "transactions_buyer_id_fk", column: "buyer_id"

end
