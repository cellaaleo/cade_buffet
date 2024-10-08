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

ActiveRecord::Schema[7.1].define(version: 2024_09_25_102410) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_customers_on_cpf", unique: true
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.integer "venue_id", null: false
    t.string "name"
    t.string "description"
    t.integer "minimum_guests_number"
    t.integer "duration"
    t.text "menu"
    t.boolean "has_alcoholic_drinks"
    t.boolean "has_decorations"
    t.boolean "has_parking_service"
    t.boolean "has_valet_service"
    t.boolean "can_be_catering"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "maximum_guests_number"
    t.integer "status", default: 0
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "venue_id", null: false
    t.integer "event_id", null: false
    t.date "event_date"
    t.integer "number_of_guests"
    t.string "event_details"
    t.string "code"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "event_address"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["event_id"], name: "index_orders_on_event_id"
    t.index ["venue_id"], name: "index_orders_on_venue_id"
  end

  create_table "prices", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "weekday_base_price"
    t.integer "weekday_plus_per_person"
    t.integer "weekday_plus_per_hour"
    t.integer "weekend_base_price"
    t.integer "weekend_plus_per_person"
    t.integer "weekend_plus_per_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_prices_on_event_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "discount_or_extra_fee"
    t.string "discount_or_extra_fee_description"
    t.date "expiry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.index ["order_id"], name: "index_quotations_on_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "buffet_owner", default: true
    t.boolean "admin", default: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "brand_name"
    t.string "corporate_name"
    t.string "registration_number"
    t.string "phone_number"
    t.string "email"
    t.string "address"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "payment_methods"
    t.integer "status", default: 0
    t.index ["registration_number"], name: "index_venues_on_registration_number", unique: true
    t.index ["user_id"], name: "index_venues_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "events", "venues"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "events"
  add_foreign_key "orders", "venues"
  add_foreign_key "prices", "events"
  add_foreign_key "quotations", "orders"
  add_foreign_key "venues", "users"
end
