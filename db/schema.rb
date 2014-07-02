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

ActiveRecord::Schema.define(version: 20140702021109) do

  create_table "attachinary_files", force: true do |t|
    t.integer  "attachinariable_id"
    t.string   "attachinariable_type"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachinary_files", ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent"

  create_table "categories", force: true do |t|
    t.string   "name",           limit: 100
    t.integer  "parent_id"
    t.integer  "level"
    t.integer  "position"
    t.integer  "children_count",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["children_count"], name: "index_categories_on_children_count"
  add_index "categories", ["level"], name: "index_categories_on_level"
  add_index "categories", ["name"], name: "index_categories_on_name"
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"
  add_index "categories", ["position"], name: "index_categories_on_position"

  create_table "conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "listing_categories", force: true do |t|
    t.integer  "category_id"
    t.integer  "listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_categories", ["category_id"], name: "index_listing_categories_on_category_id"
  add_index "listing_categories", ["listing_id"], name: "index_listing_categories_on_listing_id"

  create_table "listing_conversations", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_conversations", ["conversation_id"], name: "index_listing_conversations_on_conversation_id"
  add_index "listing_conversations", ["created_at"], name: "index_listing_conversations_on_created_at"
  add_index "listing_conversations", ["listing_id"], name: "index_listing_conversations_on_listing_id"

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

  create_table "listing_reports", force: true do |t|
    t.integer  "listing_id"
    t.integer  "user_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_reports", ["created_at"], name: "index_listing_reports_on_created_at"
  add_index "listing_reports", ["listing_id"], name: "index_listing_reports_on_listing_id"
  add_index "listing_reports", ["user_id"], name: "index_listing_reports_on_user_id"

  create_table "listings", force: true do |t|
    t.integer  "user_id"
    t.string   "state",           limit: 20
    t.string   "title",           limit: 100
    t.string   "slug",            limit: 100
    t.text     "description"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "images_count",                default: 0
    t.text     "shipping_prices"
    t.text     "data"
  end

  add_index "listings", ["created_at"], name: "index_listings_on_created_at"
  add_index "listings", ["images_count"], name: "index_listings_on_images_count"
  add_index "listings", ["price"], name: "index_listings_on_price"
  add_index "listings", ["slug"], name: "index_listings_on_slug"
  add_index "listings", ["state"], name: "index_listings_on_state"
  add_index "listings", ["title"], name: "index_listings_on_title"
  add_index "listings", ["user_id"], name: "index_listings_on_user_id"

  create_table "notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "notifications", ["conversation_id"], name: "index_notifications_on_conversation_id"

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

  create_table "payments", force: true do |t|
    t.integer  "listing_id"
    t.integer  "buyer_id"
    t.string   "state",          limit: 20
    t.string   "key",            limit: 100
    t.string   "payment_url"
    t.string   "error_message"
    t.datetime "canceled_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reviewed",                   default: false
    t.integer  "listing_price",              default: 0
    t.integer  "shipping_price",             default: 0
    t.string   "shipping_to",    limit: 20
  end

  add_index "payments", ["buyer_id"], name: "index_payments_on_buyer_id"
  add_index "payments", ["canceled_at"], name: "index_payments_on_canceled_at"
  add_index "payments", ["completed_at"], name: "index_payments_on_completed_at"
  add_index "payments", ["created_at"], name: "index_payments_on_created_at"
  add_index "payments", ["key"], name: "index_payments_on_key"
  add_index "payments", ["listing_id"], name: "index_payments_on_listing_id"
  add_index "payments", ["listing_price"], name: "index_payments_on_listing_price"
  add_index "payments", ["reviewed"], name: "index_payments_on_reviewed"
  add_index "payments", ["shipping_price"], name: "index_payments_on_shipping_price"
  add_index "payments", ["shipping_to"], name: "index_payments_on_shipping_to"
  add_index "payments", ["state"], name: "index_payments_on_state"

  create_table "phone_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "to",          limit: 20
    t.string   "state",       limit: 20
    t.string   "code",        limit: 10
    t.datetime "sent_at"
    t.datetime "verified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_tokens", ["code"], name: "index_phone_tokens_on_code"
  add_index "phone_tokens", ["sent_at"], name: "index_phone_tokens_on_sent_at"
  add_index "phone_tokens", ["state"], name: "index_phone_tokens_on_state"
  add_index "phone_tokens", ["user_id"], name: "index_phone_tokens_on_user_id"
  add_index "phone_tokens", ["verified_at"], name: "index_phone_tokens_on_verified_at"

  create_table "plan_charges", force: true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.string   "state",      limit: 20
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plan_charges", ["created_at"], name: "index_plan_charges_on_created_at"
  add_index "plan_charges", ["plan_id"], name: "index_plan_charges_on_plan_id"
  add_index "plan_charges", ["state"], name: "index_plan_charges_on_state"
  add_index "plan_charges", ["user_id"], name: "index_plan_charges_on_user_id"

  create_table "plans", force: true do |t|
    t.string   "name",                limit: 50
    t.string   "state",               limit: 20
    t.integer  "amount"
    t.boolean  "subscription"
    t.string   "interval",            limit: 20
    t.integer  "interval_count"
    t.integer  "trial_period_days"
    t.integer  "charges_count",                  default: 0
    t.integer  "subscriptions_count",            default: 0
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["amount"], name: "index_plans_on_amount"
  add_index "plans", ["charges_count"], name: "index_plans_on_charges_count"
  add_index "plans", ["interval"], name: "index_plans_on_interval"
  add_index "plans", ["interval_count"], name: "index_plans_on_interval_count"
  add_index "plans", ["name"], name: "index_plans_on_name"
  add_index "plans", ["state"], name: "index_plans_on_state"
  add_index "plans", ["subscription"], name: "index_plans_on_subscription"
  add_index "plans", ["subscriptions_count"], name: "index_plans_on_subscriptions_count"
  add_index "plans", ["trial_period_days"], name: "index_plans_on_trial_period_days"

  create_table "receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "receipts", ["notification_id"], name: "index_receipts_on_notification_id"

  create_table "review_ratings", force: true do |t|
    t.integer "review_id"
    t.string  "name",      limit: 20
    t.float   "rating",               default: 0.0
  end

  add_index "review_ratings", ["name"], name: "index_review_ratings_on_name"
  add_index "review_ratings", ["rating"], name: "index_review_ratings_on_rating"
  add_index "review_ratings", ["review_id"], name: "index_review_ratings_on_review_id"

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "listing_id"
    t.float    "avg_rating", default: 0.0
    t.text     "body"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["avg_rating"], name: "index_reviews_on_avg_rating"
  add_index "reviews", ["created_at"], name: "index_reviews_on_created_at"
  add_index "reviews", ["listing_id"], name: "index_reviews_on_listing_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.string   "state",      limit: 20
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["created_at"], name: "index_subscriptions_on_created_at"
  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id"
  add_index "subscriptions", ["state"], name: "index_subscriptions_on_state"
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id"

  create_table "user_avatar_images", force: true do |t|
    t.integer  "user_id"
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

  add_index "user_avatar_images", ["position"], name: "index_user_avatar_images_on_position"
  add_index "user_avatar_images", ["user_id"], name: "index_user_avatar_images_on_user_id"

  create_table "user_cover_images", force: true do |t|
    t.integer  "user_id"
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

  add_index "user_cover_images", ["position"], name: "index_user_cover_images_on_position"
  add_index "user_cover_images", ["user_id"], name: "index_user_cover_images_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                                                         default: "", null: false
    t.string   "encrypted_password",                                            default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                 default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token",    limit: 100
    t.string   "handle",                  limit: 100
    t.string   "first_name",              limit: 50
    t.string   "last_name",               limit: 50
    t.integer  "roles"
    t.string   "public_id",               limit: 50
    t.string   "version",                 limit: 50
    t.integer  "width"
    t.integer  "height"
    t.string   "format",                  limit: 50
    t.string   "resource_type",           limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about"
    t.text     "data"
    t.string   "phone",                   limit: 30
    t.string   "website",                 limit: 100
    t.string   "street",                  limit: 60
    t.string   "city",                    limit: 60
    t.string   "state_code",              limit: 2
    t.string   "postal_code",             limit: 16
    t.decimal  "lat",                                 precision: 15, scale: 10
    t.decimal  "lng",                                 precision: 15, scale: 10
    t.string   "paypal_email",            limit: 100
    t.integer  "listing_credits",                                               default: 0
    t.string   "customer_id",             limit: 100
    t.integer  "charges_count",                                                 default: 0
    t.integer  "subscriptions_count",                                           default: 0
    t.integer  "pending_listing_reviews",                                       default: 0
    t.integer  "inbox_unread_count",                                            default: 0
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true
  add_index "users", ["charges_count"], name: "index_users_on_charges_count"
  add_index "users", ["customer_id"], name: "index_users_on_customer_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["first_name"], name: "index_users_on_first_name"
  add_index "users", ["handle"], name: "index_users_on_handle"
  add_index "users", ["inbox_unread_count"], name: "index_users_on_inbox_unread_count"
  add_index "users", ["last_name"], name: "index_users_on_last_name"
  add_index "users", ["listing_credits"], name: "index_users_on_listing_credits"
  add_index "users", ["paypal_email"], name: "index_users_on_paypal_email"
  add_index "users", ["pending_listing_reviews"], name: "index_users_on_pending_listing_reviews"
  add_index "users", ["postal_code"], name: "index_users_on_postal_code"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["roles"], name: "index_users_on_roles"
  add_index "users", ["state_code"], name: "index_users_on_state_code"
  add_index "users", ["subscriptions_count"], name: "index_users_on_subscriptions_count"

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
