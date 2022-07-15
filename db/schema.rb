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

ActiveRecord::Schema.define(version: 20190919055759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "band_musics", force: :cascade do |t|
    t.bigint "band_id"
    t.string "music_file_name"
    t.string "music_content_type"
    t.integer "music_file_size"
    t.datetime "music_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_band_musics_on_band_id"
  end

  create_table "bands", force: :cascade do |t|
    t.string "band_type"
    t.string "band_genre"
    t.string "band_sec_genre"
    t.string "band_name"
    t.string "sound_link"
    t.string "face_link"
    t.string "spot_link"
    t.text "summary"
    t.string "address"
    t.boolean "active"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["user_id"], name: "index_bands_on_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "band_id"
    t.bigint "venue_id"
    t.datetime "date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "payout"
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.boolean "is_paid", default: false
    t.datetime "paid_at"
    t.integer "request_count", default: 0
    t.datetime "request_sent_at"
    t.integer "calendar_time_id"
    t.index ["band_id"], name: "index_bookings_on_band_id"
    t.index ["venue_id"], name: "index_bookings_on_venue_id"
  end

  create_table "calendar_times", force: :cascade do |t|
    t.bigint "calendar_id"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_calendar_times_on_calendar_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.date "day"
    t.integer "payout"
    t.integer "status"
    t.bigint "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venue_id"], name: "index_calendars_on_venue_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "context"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["venue_id"], name: "index_photos_on_venue_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.bigint "band_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["band_id"], name: "index_pictures_on_band_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.integer "star", default: 1
    t.bigint "venue_id"
    t.bigint "band_id"
    t.bigint "booking_id"
    t.bigint "guest_id"
    t.bigint "host_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_reviews_on_band_id"
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["guest_id"], name: "index_reviews_on_guest_id"
    t.index ["host_id"], name: "index_reviews_on_host_id"
    t.index ["venue_id"], name: "index_reviews_on_venue_id"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "enable_sms", default: true
    t.boolean "enable_email", default: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fullname"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.string "phone_number"
    t.text "description"
    t.string "pin"
    t.boolean "phone_verified"
    t.string "stripe_id"
    t.string "merchant_id"
    t.integer "unread", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "venue_type"
    t.string "gig_type"
    t.integer "capacity"
    t.string "listing_name"
    t.text "summary"
    t.text "comments"
    t.string "address"
    t.boolean "is_alternative"
    t.boolean "is_americana"
    t.boolean "is_blues"
    t.boolean "is_christian"
    t.boolean "is_classical"
    t.boolean "is_comedy"
    t.boolean "is_country"
    t.boolean "is_edm"
    t.boolean "is_electronic"
    t.boolean "is_folk"
    t.boolean "is_hiphop"
    t.boolean "is_jazz"
    t.boolean "is_latin"
    t.boolean "is_metal"
    t.boolean "is_pop"
    t.boolean "is_rb"
    t.boolean "is_rock"
    t.boolean "is_spokenword"
    t.boolean "is_world"
    t.integer "payout"
    t.boolean "active"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "instant", default: 0
    t.index ["user_id"], name: "index_venues_on_user_id"
  end

  add_foreign_key "bands", "users"
  add_foreign_key "bookings", "bands"
  add_foreign_key "bookings", "venues"
  add_foreign_key "calendars", "venues"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "photos", "venues"
  add_foreign_key "pictures", "bands"
  add_foreign_key "reviews", "bands"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "users", column: "guest_id"
  add_foreign_key "reviews", "users", column: "host_id"
  add_foreign_key "reviews", "venues"
  add_foreign_key "settings", "users"
  add_foreign_key "venues", "users"
end
