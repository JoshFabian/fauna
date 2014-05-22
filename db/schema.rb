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

ActiveRecord::Schema.define(version: 20140521200739) do

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
