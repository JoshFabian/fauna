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

ActiveRecord::Schema.define(version: 20140524161435) do

  create_table "categories", force: true do |t|
    t.string   "name",           limit: 100
    t.integer  "parent_id"
    t.integer  "level"
    t.integer  "children_count",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["children_count"], name: "index_categories_on_children_count"
  add_index "categories", ["level"], name: "index_categories_on_level"
  add_index "categories", ["name"], name: "index_categories_on_name"
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"

  create_table "listing_categories", force: true do |t|
    t.integer  "category_id"
    t.integer  "listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_categories", ["category_id"], name: "index_listing_categories_on_category_id"
  add_index "listing_categories", ["listing_id"], name: "index_listing_categories_on_listing_id"

  create_table "listing_images", force: true do |t|
    t.integer  "listing_id"
    t.integer  "position"
    t.string   "etag",          limit: 100
    t.string   "public_id",     limit: 100
    t.string   "version",       limit: 100
    t.integer  "bytes"
    t.integer  "height"
    t.integer  "width"
    t.string   "format",        limit: 100
    t.string   "resource_type", limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_images", ["listing_id"], name: "index_listing_images_on_listing_id"
  add_index "listing_images", ["position"], name: "index_listing_images_on_position"

  create_table "listings", force: true do |t|
    t.integer  "user_id"
    t.string   "state",        limit: 20
    t.string   "title",        limit: 100
    t.text     "description"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "images_count",             default: 0
  end

  add_index "listings", ["created_at"], name: "index_listings_on_created_at"
  add_index "listings", ["images_count"], name: "index_listings_on_images_count"
  add_index "listings", ["price"], name: "index_listings_on_price"
  add_index "listings", ["state"], name: "index_listings_on_state"
  add_index "listings", ["title"], name: "index_listings_on_title"
  add_index "listings", ["user_id"], name: "index_listings_on_user_id"

  create_table "oauths", force: true do |t|
    t.integer  "user_id"
    t.string   "provider",         limit: 20
    t.string   "uid",              limit: 50
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.text     "data"
  end

  add_index "oauths", ["provider"], name: "index_oauths_on_provider"
  add_index "oauths", ["uid"], name: "index_oauths_on_uid"
  add_index "oauths", ["user_id"], name: "index_oauths_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token",   limit: 100
    t.string   "handle",                 limit: 100
    t.string   "first_name",             limit: 50
    t.string   "last_name",              limit: 50
    t.integer  "roles"
    t.string   "public_id",              limit: 50
    t.string   "version",                limit: 50
    t.integer  "width"
    t.integer  "height"
    t.string   "format",                 limit: 50
    t.string   "resource_type",          limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["first_name"], name: "index_users_on_first_name"
  add_index "users", ["handle"], name: "index_users_on_handle"
  add_index "users", ["last_name"], name: "index_users_on_last_name"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["roles"], name: "index_users_on_roles"

  create_table "waitlists", force: true do |t|
    t.string   "email",        limit: 50
    t.string   "code",         limit: 20
    t.string   "role",         limit: 20
    t.string   "referer",      limit: 50
    t.integer  "signup_count",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waitlists", ["code"], name: "index_waitlists_on_code"
  add_index "waitlists", ["email"], name: "index_waitlists_on_email"
  add_index "waitlists", ["referer"], name: "index_waitlists_on_referer"
  add_index "waitlists", ["role"], name: "index_waitlists_on_role"
  add_index "waitlists", ["signup_count"], name: "index_waitlists_on_signup_count"

end
