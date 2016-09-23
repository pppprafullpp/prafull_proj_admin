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

ActiveRecord::Schema.define(version: 20160922061830) do

  create_table "account_referral_amounts", force: :cascade do |t|
    t.integer  "account_referral_id",     limit: 4
    t.integer  "referral_gift_amount_id", limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "account_referrals", force: :cascade do |t|
    t.integer  "referral_id",         limit: 4
    t.integer  "referrer_id",         limit: 4
    t.float    "referral_gift_coins", limit: 24
    t.float    "referrer_gift_coins", limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "additional_offers", force: :cascade do |t|
    t.integer  "deal_id",       limit: 4
    t.string   "title",         limit: 255
    t.text     "description",   limit: 65535
    t.float    "price",         limit: 24,    default: 0.0,   null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "is_nationwide",               default: false
    t.boolean  "is_active",                   default: true
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "additional_offers", ["deal_id"], name: "index_additional_offers_on_deal_id", using: :btree

  create_table "additional_offers_zipcodes", id: false, force: :cascade do |t|
    t.integer "additional_offer_id", limit: 4, null: false
    t.integer "zipcode_id",          limit: 4, null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "password",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "advertisements", force: :cascade do |t|
    t.integer  "service_category_id",   limit: 4
    t.string   "service_category_name", limit: 255
    t.string   "name",                  limit: 255
    t.string   "url",                   limit: 255
    t.string   "image",                 limit: 255
    t.boolean  "status",                            default: true
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "advertisements", ["service_category_id"], name: "index_advertisements_on_service_category_id", using: :btree

  create_table "app_user_addresses", force: :cascade do |t|
    t.integer  "app_user_id",    limit: 4
    t.string   "address_name",   limit: 255
    t.string   "zip",            limit: 255
    t.string   "address1",       limit: 255
    t.string   "address2",       limit: 255
    t.integer  "address_type",   limit: 4
    t.string   "contact_number", limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "state",          limit: 65535
    t.string   "city",           limit: 255
    t.boolean  "is_default",                   default: false
  end

  create_table "app_users", force: :cascade do |t|
    t.string   "user_type",                limit: 25,  default: "residence", null: false
    t.string   "business_name",            limit: 255, default: "",          null: false
    t.string   "first_name",               limit: 255, default: "",          null: false
    t.string   "last_name",                limit: 255, default: "",          null: false
    t.string   "email",                    limit: 255, default: "",          null: false
    t.string   "encrypted_password",       limit: 255, default: "",          null: false
    t.string   "address",                  limit: 255
    t.string   "state",                    limit: 255
    t.string   "city",                     limit: 255
    t.string   "zip",                      limit: 255
    t.string   "gcm_id",                   limit: 255
    t.string   "avatar",                   limit: 255
    t.string   "unhashed_password",        limit: 255
    t.string   "device_flag",              limit: 255
    t.string   "reset_password_token",     limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            limit: 4,   default: 0,           null: false
    t.boolean  "active",                               default: true
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",       limit: 255
    t.string   "last_sign_in_ip",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "referral_code",            limit: 255, default: ""
    t.boolean  "refer_status",                         default: false
    t.float    "total_amount",             limit: 24,  default: 0.0
    t.string   "customer_service_account", limit: 255
    t.string   "customer_status",          limit: 255
    t.string   "credit_worthy",            limit: 255
    t.string   "customer_contract",        limit: 255
    t.string   "mobile",                   limit: 255
    t.integer  "is_service_address_same",  limit: 4
    t.integer  "is_shipping_address_same", limit: 4
    t.string   "primary_id",               limit: 255
    t.string   "secondary_id",             limit: 255
    t.string   "primary_id_number",        limit: 255
    t.string   "secondary_id_number",      limit: 255
    t.string   "email_verification_token", limit: 255
    t.boolean  "email_verified"
  end

  add_index "app_users", ["email"], name: "index_app_users_on_email", unique: true, using: :btree
  add_index "app_users", ["reset_password_token"], name: "index_app_users_on_reset_password_token", unique: true, using: :btree

  create_table "bandwidth_calculator_settings", force: :cascade do |t|
    t.integer "email",                 limit: 4
    t.integer "web_page",              limit: 4
    t.integer "video_calling",         limit: 4
    t.integer "audio_calling",         limit: 4
    t.integer "photo_upload_download", limit: 4
    t.integer "video_streaming",       limit: 4
  end

  create_table "bulk_notifications", force: :cascade do |t|
    t.string   "state",      limit: 255
    t.string   "city",       limit: 255
    t.string   "zip",        limit: 255
    t.text     "message",    limit: 65535
    t.string   "category",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "bundle_deal_attributes", force: :cascade do |t|
    t.integer  "deal_id",                    limit: 4
    t.string   "bundle_combo",               limit: 255
    t.float    "download",                   limit: 24
    t.float    "upload",                     limit: 24
    t.float    "data",                       limit: 24
    t.boolean  "static_ip"
    t.string   "domestic_call_minutes",      limit: 255
    t.string   "international_call_minutes", limit: 255
    t.integer  "free_channels",              limit: 4
    t.text     "free_channels_list",         limit: 65535
    t.integer  "premium_channels",           limit: 4
    t.text     "premium_channels_list",      limit: 65535
    t.integer  "hd_channels",                limit: 4
    t.text     "hd_channels_list",           limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "description",                limit: 65535
  end

  create_table "bundle_equipments", force: :cascade do |t|
    t.integer  "bundle_deal_attribute_id", limit: 4
    t.string   "name",                     limit: 255
    t.string   "make",                     limit: 255
    t.decimal  "price",                                  precision: 30, scale: 2, default: 0.0, null: false
    t.text     "installation",             limit: 65535
    t.string   "activation",               limit: 255
    t.string   "offer",                    limit: 255
    t.boolean  "is_active"
    t.datetime "created_at",                                                                    null: false
    t.datetime "updated_at",                                                                    null: false
    t.integer  "deal_id",                  limit: 4
  end

  create_table "bundle_service_preferences", force: :cascade do |t|
    t.integer  "service_preference_id",        limit: 4
    t.float    "upload_speed",                 limit: 24
    t.float    "download_speed",               limit: 24
    t.float    "data",                         limit: 24
    t.integer  "free_channels",                limit: 4
    t.integer  "premium_channels",             limit: 4
    t.integer  "domestic_call_minutes",        limit: 4
    t.integer  "international_call_minutes",   limit: 4
    t.float    "data_plan",                    limit: 24
    t.float    "data_speed",                   limit: 24
    t.boolean  "domestic_call_unlimited",                  default: false
    t.boolean  "international_call_unlimited",             default: false
    t.string   "bundle_combo",                 limit: 255
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "bundle_service_preferences", ["service_preference_id"], name: "index_bundle_service_preferences_on_service_preference_id", using: :btree

  create_table "business_addresses", force: :cascade do |t|
    t.integer  "business_id",     limit: 4
    t.integer  "address_type",    limit: 4
    t.string   "address_name",    limit: 255
    t.string   "zip",             limit: 255
    t.string   "address1",        limit: 255
    t.string   "address2",        limit: 255
    t.string   "contact_number",  limit: 255
    t.string   "manager_name",    limit: 255
    t.string   "manager_contact", limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.text     "state",           limit: 65535
    t.string   "city",            limit: 255
    t.boolean  "is_default",                    default: false
  end

  create_table "business_app_users", force: :cascade do |t|
    t.integer "business_id", limit: 4
    t.integer "app_user_id", limit: 4
    t.string  "role",        limit: 255
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "business_name",            limit: 255
    t.integer  "business_type",            limit: 4
    t.string   "business_status",          limit: 255
    t.string   "business_dba",             limit: 255
    t.string   "federal_number",           limit: 255
    t.string   "db_number",                limit: 255
    t.date     "dob"
    t.string   "ssn",                      limit: 255
    t.string   "contact_number",           limit: 255
    t.string   "status",                   limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "manager_name",             limit: 255
    t.string   "manager_contact",          limit: 255
    t.integer  "is_service_address_same",  limit: 4
    t.integer  "is_shipping_address_same", limit: 4
  end

  create_table "cable_deal_attributes", force: :cascade do |t|
    t.integer  "deal_id",               limit: 4
    t.integer  "free_channels",         limit: 4
    t.text     "free_channels_list",    limit: 65535
    t.integer  "premium_channels",      limit: 4
    t.text     "premium_channels_list", limit: 65535
    t.integer  "hd_channels",           limit: 4
    t.text     "hd_channels_list",      limit: 65535
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.text     "channel_ids",           limit: 65535
    t.text     "channel_package_ids",   limit: 65535
    t.integer  "channel_count",         limit: 4
    t.text     "description",           limit: 65535
    t.string   "title",                 limit: 255
    t.decimal  "amount",                              precision: 5, scale: 2
  end

  add_index "cable_deal_attributes", ["deal_id"], name: "index_cable_deal_attributes_on_deal_id", using: :btree

  create_table "cable_equipments", force: :cascade do |t|
    t.integer  "cable_deal_attribute_id", limit: 4
    t.string   "name",                    limit: 255
    t.string   "make",                    limit: 255
    t.decimal  "price",                                 precision: 30, scale: 2, default: 0.0, null: false
    t.text     "installation",            limit: 65535
    t.string   "activation",              limit: 255
    t.string   "offer",                   limit: 255
    t.boolean  "is_active"
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
    t.integer  "deal_id",                 limit: 4
    t.text     "description",             limit: 65535
  end

  create_table "cable_service_preferences", force: :cascade do |t|
    t.integer  "service_preference_id", limit: 4
    t.integer  "free_channels",         limit: 4
    t.integer  "premium_channels",      limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "cable_service_preferences", ["service_preference_id"], name: "index_cable_service_preferences_on_service_preference_id", using: :btree

  create_table "cashout_infos", force: :cascade do |t|
    t.integer  "app_user_id",    limit: 4
    t.float    "reedeem_amount", limit: 24
    t.string   "email_id",       limit: 255
    t.boolean  "is_cash"
    t.string   "gift_card_type", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "cellphone_deal_attributes", force: :cascade do |t|
    t.integer  "deal_id",                    limit: 4
    t.integer  "no_of_lines",                limit: 4,                              default: 0,     null: false
    t.decimal  "price_per_line",                           precision: 5,  scale: 2, default: 0.0,   null: false
    t.string   "domestic_call_minutes",      limit: 255
    t.string   "domestic_text",              limit: 255
    t.string   "international_call_minutes", limit: 255
    t.string   "international_text",         limit: 255
    t.float    "data_plan",                  limit: 24
    t.decimal  "data_plan_price",                          precision: 5,  scale: 2, default: 0.0,   null: false
    t.float    "additional_data",            limit: 24
    t.decimal  "additional_data_price",                    precision: 5,  scale: 2, default: 0.0,   null: false
    t.boolean  "rollover_data",                                                     default: false
    t.datetime "created_at",                                                                        null: false
    t.datetime "updated_at",                                                                        null: false
    t.decimal  "effective_price",                          precision: 10,           default: 0
    t.text     "description",                limit: 65535
    t.string   "title",                      limit: 255
  end

  add_index "cellphone_deal_attributes", ["deal_id"], name: "index_cellphone_deal_attributes_on_deal_id", using: :btree

  create_table "cellphone_details", force: :cascade do |t|
    t.string   "cellphone_name", limit: 255
    t.string   "brand",          limit: 255
    t.text     "description",    limit: 65535
    t.boolean  "status"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "image",          limit: 255
  end

  create_table "cellphone_equipments", force: :cascade do |t|
    t.integer  "cellphone_deal_attribute_id", limit: 4
    t.string   "model",                       limit: 255
    t.string   "make",                        limit: 255
    t.integer  "memory",                      limit: 4
    t.decimal  "price",                                     precision: 30, scale: 2, default: 0.0, null: false
    t.text     "installation",                limit: 65535
    t.string   "activation",                  limit: 255
    t.string   "offer",                       limit: 255
    t.boolean  "is_active"
    t.datetime "created_at",                                                                       null: false
    t.datetime "updated_at",                                                                       null: false
    t.integer  "deal_id",                     limit: 4
    t.text     "available_colors",            limit: 65535
    t.integer  "cellphone_detail_id",         limit: 4
  end

  create_table "cellphone_service_preferences", force: :cascade do |t|
    t.integer  "service_preference_id",        limit: 4
    t.integer  "domestic_call_minutes",        limit: 4
    t.integer  "international_call_minutes",   limit: 4
    t.float    "data_plan",                    limit: 24
    t.float    "data_speed",                   limit: 24
    t.boolean  "domestic_call_unlimited",                 default: false
    t.boolean  "international_call_unlimited",            default: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "no_of_lines",                  limit: 4
  end

  add_index "cellphone_service_preferences", ["service_preference_id"], name: "index_cellphone_service_preferences_on_service_preference_id", using: :btree

  create_table "channel_packages", force: :cascade do |t|
    t.string   "package_name",        limit: 255
    t.string   "package_code",        limit: 255
    t.integer  "channel_count",       limit: 4
    t.text     "channel_ids",         limit: 65535
    t.text     "description",         limit: 65535
    t.string   "image",               limit: 255
    t.boolean  "status",                                                    default: true
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.decimal  "price",                             precision: 5, scale: 2
    t.integer  "service_provider_id", limit: 4
  end

  create_table "channels", force: :cascade do |t|
    t.string   "category_name",       limit: 255
    t.string   "channel_name",        limit: 255
    t.string   "channel_code",        limit: 255
    t.string   "channel_type",        limit: 255,   default: "normal"
    t.text     "description",         limit: 65535
    t.boolean  "is_hd",                             default: false
    t.string   "image",               limit: 255
    t.boolean  "status",                            default: true
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "service_provider_id", limit: 4
  end

  create_table "checklists", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "status",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_ratings", force: :cascade do |t|
    t.integer  "app_user_id",   limit: 4
    t.integer  "deal_id",       limit: 4
    t.float    "rating_point",  limit: 24
    t.boolean  "status",                      default: true
    t.text     "comment_title", limit: 65535
    t.text     "comment_text",  limit: 65535
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "comment_ratings", ["app_user_id"], name: "index_comment_ratings_on_app_user_id", using: :btree
  add_index "comment_ratings", ["deal_id"], name: "index_comment_ratings_on_deal_id", using: :btree

  create_table "configurables", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "configurables", ["name"], name: "index_configurables_on_name", using: :btree

  create_table "deal_extra_services", force: :cascade do |t|
    t.integer  "extra_service_id", limit: 4
    t.integer  "deal_id",          limit: 4
    t.decimal  "price",                      precision: 5, scale: 2
    t.boolean  "status"
    t.integer  "service_term",     limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "deal_include_zipcodes", force: :cascade do |t|
    t.integer  "deal_id",    limit: 4, null: false
    t.integer  "zipcode_id", limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "deals", force: :cascade do |t|
    t.integer  "service_category_id", limit: 4
    t.integer  "service_provider_id", limit: 4
    t.string   "title",               limit: 255
    t.text     "short_description",   limit: 65535
    t.text     "detail_description",  limit: 65535
    t.float    "price",               limit: 24,                            default: 0.0,         null: false
    t.boolean  "is_contract",                                               default: false,       null: false
    t.integer  "contract_period",     limit: 4,                             default: 0,           null: false
    t.string   "url",                 limit: 255
    t.string   "image",               limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "is_nationwide",                                             default: false
    t.string   "deal_type",           limit: 100,                           default: "residence", null: false
    t.boolean  "is_active",                                                 default: true
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
    t.boolean  "is_sponsored",                                              default: false
    t.decimal  "effective_price",                   precision: 5, scale: 2
    t.boolean  "is_customisable",                                           default: false
  end

  add_index "deals", ["service_category_id"], name: "index_deals_on_service_category_id", using: :btree
  add_index "deals", ["service_provider_id"], name: "index_deals_on_service_provider_id", using: :btree

  create_table "deals_zipcodes", id: false, force: :cascade do |t|
    t.integer "deal_id",    limit: 4, null: false
    t.integer "zipcode_id", limit: 4, null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "device_registers", force: :cascade do |t|
    t.text     "imei",       limit: 65535
    t.text     "device_id",  limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "token",      limit: 65535
  end

  create_table "device_trackers", force: :cascade do |t|
    t.text     "device_id",          limit: 65535
    t.text     "service_provider",   limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "imei",               limit: 65535
    t.boolean  "dual_sim"
    t.text     "country",            limit: 65535
    t.text     "sim_operator",       limit: 65535
    t.text     "sim_serial_number",  limit: 65535
    t.text     "subscriber_id",      limit: 65535
    t.text     "voice_mail_number",  limit: 65535
    t.text     "location",           limit: 65535
    t.text     "device_type",        limit: 65535
    t.text     "provider_type",      limit: 65535
    t.boolean  "roaming"
    t.integer  "device_register_id", limit: 4
  end

  create_table "equipment_colors", force: :cascade do |t|
    t.string   "color_name", limit: 255
    t.boolean  "status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "color_code", limit: 255
    t.string   "image",      limit: 255
  end

  create_table "extra_services", force: :cascade do |t|
    t.string   "service_name",        limit: 255
    t.integer  "service_category_id", limit: 4
    t.boolean  "status"
    t.text     "service_description", limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "gifts", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "description",                limit: 255
    t.float    "amount",                     limit: 24
    t.integer  "activation_count_condition", limit: 4,   default: 0
    t.boolean  "is_active",                              default: true
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "image",                      limit: 255
  end

  create_table "internet_deal_attributes", force: :cascade do |t|
    t.integer  "deal_id",               limit: 4
    t.float    "download",              limit: 24
    t.float    "upload",                limit: 24
    t.float    "data",                  limit: 24
    t.string   "email",                 limit: 255
    t.string   "online_storage",        limit: 255
    t.text     "wifi_hotspot_networks", limit: 65535
    t.boolean  "static_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "description",           limit: 65535
  end

  add_index "internet_deal_attributes", ["deal_id"], name: "index_internet_deal_attributes_on_deal_id", using: :btree

  create_table "internet_equipments", force: :cascade do |t|
    t.integer  "internet_deal_attribute_id", limit: 4
    t.string   "name",                       limit: 255
    t.string   "make",                       limit: 255
    t.decimal  "price",                                    precision: 30, scale: 2, default: 0.0, null: false
    t.text     "installation",               limit: 65535
    t.string   "activation",                 limit: 255
    t.string   "offer",                      limit: 255
    t.boolean  "is_active"
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
    t.integer  "deal_id",                    limit: 4
  end

  create_table "internet_service_preferences", force: :cascade do |t|
    t.integer  "service_preference_id", limit: 4
    t.float    "upload_speed",          limit: 24
    t.float    "download_speed",        limit: 24
    t.string   "online_storage",        limit: 255
    t.string   "wifi_hotspot",          limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "internet_service_preferences", ["service_preference_id"], name: "index_internet_service_preferences_on_service_preference_id", using: :btree

  create_table "login_details", force: :cascade do |t|
    t.string   "partnerable_type", limit: 255
    t.integer  "partnerable_id",   limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "app_user_id",                   limit: 4
    t.boolean  "recieve_notification"
    t.integer  "day",                           limit: 4
    t.boolean  "recieve_trending_deals",                    default: true
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "repeat_notification_frequency", limit: 255, default: "Weekly"
    t.string   "trending_deal_frequency",       limit: 255, default: "Weekly"
    t.boolean  "receive_call",                              default: true
    t.integer  "min_service_provider_rating",   limit: 4
    t.integer  "min_deal_rating",               limit: 4
    t.boolean  "receive_email",                             default: true
    t.boolean  "receive_text",                              default: true
  end

  add_index "notifications", ["app_user_id"], name: "index_notifications_on_app_user_id", using: :btree

  create_table "order_addresses", force: :cascade do |t|
    t.integer  "order_id",        limit: 4
    t.integer  "address_type",    limit: 4
    t.string   "address_name",    limit: 255
    t.string   "zip",             limit: 255
    t.string   "address1",        limit: 255
    t.string   "address2",        limit: 255
    t.string   "contact_number",  limit: 255
    t.string   "manager_name",    limit: 255
    t.string   "manager_contact", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "state",           limit: 65535
    t.string   "city",            limit: 255
  end

  create_table "order_attributes", force: :cascade do |t|
    t.integer  "order_id",   limit: 4
    t.integer  "ref_id",     limit: 4
    t.string   "ref_type",   limit: 255
    t.decimal  "price",                  precision: 5, scale: 2
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "order_equipments", force: :cascade do |t|
    t.integer  "order_id",        limit: 4
    t.integer  "equipment_id",    limit: 4
    t.decimal  "equipment_price",               precision: 5, scale: 2
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.text     "color",           limit: 65535
  end

  create_table "order_extra_services", force: :cascade do |t|
    t.integer  "order_id",              limit: 4
    t.integer  "deal_extra_service_id", limit: 4
    t.string   "service_name",          limit: 255
    t.decimal  "price",                             precision: 5, scale: 2
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id",        limit: 4
    t.string   "ref_number",      limit: 255
    t.integer  "deal_id",         limit: 4
    t.float    "deal_price",      limit: 24
    t.float    "effective_price", limit: 24
    t.float    "discount_price",  limit: 24
    t.date     "activation_date"
    t.string   "status",          limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.float    "you_save",        limit: 24
  end

  create_table "orders", force: :cascade do |t|
    t.string   "order_id",            limit: 255, default: "",            null: false
    t.integer  "deal_id",             limit: 4
    t.integer  "app_user_id",         limit: 4
    t.string   "status",              limit: 255, default: "In-progress", null: false
    t.float    "deal_price",          limit: 24
    t.float    "effective_price",     limit: 24
    t.datetime "activation_date"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "order_number",        limit: 255
    t.integer  "order_type",          limit: 4
    t.integer  "security_deposit",    limit: 4
    t.string   "primary_id",          limit: 255
    t.string   "secondary_id",        limit: 255
    t.string   "primary_id_number",   limit: 255
    t.string   "secondary_id_number", limit: 255
  end

  create_table "pending_actions", force: :cascade do |t|
    t.integer  "action_by",       limit: 4
    t.integer  "pending_with",    limit: 4
    t.integer  "action_type",     limit: 4
    t.integer  "key",             limit: 4
    t.integer  "status",          limit: 4
    t.text     "additional_info", limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "refer_contact_details", force: :cascade do |t|
    t.integer  "app_user_id", limit: 4
    t.string   "email_id",    limit: 255
    t.string   "mobile_no",   limit: 255
    t.string   "name",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "referral_gift_amounts", force: :cascade do |t|
    t.float    "referrer_amount",     limit: 24
    t.float    "referral_amount",     limit: 24
    t.string   "referrer_gift_image", limit: 255
    t.string   "referral_gift_image", limit: 255
    t.boolean  "is_active",                       default: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "referral_infos", force: :cascade do |t|
    t.string   "first_referring_identity", limit: 255
    t.string   "referred_user",            limit: 255
    t.string   "event",                    limit: 255
    t.integer  "referring_user_coins",     limit: 4
    t.integer  "referred_user_coins",      limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sequences", force: :cascade do |t|
    t.string  "seq_type",   limit: 255
    t.integer "seq_number", limit: 4
  end

  create_table "service_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "service_preferences", force: :cascade do |t|
    t.integer  "app_user_id",           limit: 4
    t.integer  "service_category_id",   limit: 4
    t.integer  "service_provider_id",   limit: 4
    t.string   "service_category_name", limit: 255
    t.string   "service_provider_name", limit: 255
    t.float    "price",                 limit: 24
    t.boolean  "is_contract"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "plan_name",             limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "service_preferences", ["app_user_id"], name: "index_service_preferences_on_app_user_id", using: :btree
  add_index "service_preferences", ["service_category_id"], name: "index_service_preferences_on_service_category_id", using: :btree
  add_index "service_preferences", ["service_provider_id"], name: "index_service_preferences_on_service_provider_id", using: :btree

  create_table "service_provider_checklists", force: :cascade do |t|
    t.integer "checklist_id",        limit: 4
    t.integer "service_provider_id", limit: 4
    t.integer "service_category_id", limit: 4
    t.boolean "is_mandatory"
    t.integer "status",              limit: 4
  end

  create_table "service_providers", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "service_category_id", limit: 4
    t.string   "address",             limit: 255
    t.string   "state",               limit: 255
    t.string   "city",                limit: 255
    t.string   "zip",                 limit: 255
    t.string   "email",               limit: 255
    t.string   "telephone",           limit: 255
    t.string   "logo",                limit: 255
    t.boolean  "is_preferred",                    default: false
    t.boolean  "is_active",                       default: true
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "service_providers", ["service_category_id"], name: "index_service_providers_on_service_category_id", using: :btree

  create_table "statelists", force: :cascade do |t|
    t.text     "state",      limit: 65535
    t.text     "city",       limit: 65535
    t.text     "county",     limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "subscribe_deals", force: :cascade do |t|
    t.integer  "app_user_id",   limit: 4
    t.integer  "deal_id",       limit: 4
    t.boolean  "active_status",           default: false
    t.integer  "category_id",   limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "subscribe_deals", ["app_user_id"], name: "index_subscribe_deals_on_app_user_id", using: :btree
  add_index "subscribe_deals", ["deal_id"], name: "index_subscribe_deals_on_deal_id", using: :btree

  create_table "telephone_deal_attributes", force: :cascade do |t|
    t.integer  "deal_id",                          limit: 4
    t.string   "domestic_call_minutes",            limit: 25
    t.integer  "domestic_receive_minutes",         limit: 4
    t.integer  "domestic_additional_minutes",      limit: 4
    t.string   "international_call_minutes",       limit: 25
    t.integer  "international_landline_minutes",   limit: 4
    t.integer  "international_mobile_minutes",     limit: 4
    t.integer  "international_additional_minutes", limit: 4
    t.text     "countries",                        limit: 65535
    t.text     "features",                         limit: 65535
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.text     "description",                      limit: 65535
  end

  add_index "telephone_deal_attributes", ["deal_id"], name: "index_telephone_deal_attributes_on_deal_id", using: :btree

  create_table "telephone_equipments", force: :cascade do |t|
    t.integer  "telephone_deal_attribute_id", limit: 4
    t.string   "name",                        limit: 255
    t.string   "make",                        limit: 255
    t.decimal  "price",                                     precision: 30, scale: 2, default: 0.0, null: false
    t.text     "installation",                limit: 65535
    t.string   "activation",                  limit: 255
    t.string   "offer",                       limit: 255
    t.boolean  "is_active"
    t.datetime "created_at",                                                                       null: false
    t.datetime "updated_at",                                                                       null: false
    t.integer  "deal_id",                     limit: 4
  end

  create_table "telephone_service_preferences", force: :cascade do |t|
    t.integer  "service_preference_id",        limit: 4
    t.integer  "domestic_call_minutes",        limit: 4
    t.integer  "international_call_minutes",   limit: 4
    t.boolean  "domestic_call_unlimited",                default: false
    t.boolean  "international_call_unlimited",           default: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  add_index "telephone_service_preferences", ["service_preference_id"], name: "index_telephone_service_preferences_on_service_preference_id", using: :btree

  create_table "trending_deals", force: :cascade do |t|
    t.integer  "deal_id",            limit: 4
    t.integer  "subscription_count", limit: 4
    t.integer  "category_id",        limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "trending_deals", ["deal_id"], name: "index_trending_deals_on_deal_id", using: :btree

  create_table "user_gifts", force: :cascade do |t|
    t.integer  "app_user_id", limit: 4
    t.integer  "gift_id",     limit: 4
    t.integer  "order_id",    limit: 4
    t.string   "status",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255, default: "", null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "role",                   limit: 255
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.boolean  "enabled"
    t.integer  "failed_count",           limit: 4
    t.datetime "password_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zipcodes", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "area",       limit: 255
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.string   "country",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "additional_offers", "deals"
  add_foreign_key "advertisements", "service_categories"
  add_foreign_key "bundle_service_preferences", "service_preferences"
  add_foreign_key "cable_service_preferences", "service_preferences"
  add_foreign_key "cellphone_service_preferences", "service_preferences"
  add_foreign_key "comment_ratings", "app_users"
  add_foreign_key "comment_ratings", "deals"
  add_foreign_key "deals", "service_categories"
  add_foreign_key "internet_deal_attributes", "deals"
  add_foreign_key "internet_service_preferences", "service_preferences"
  add_foreign_key "notifications", "app_users"
  add_foreign_key "service_preferences", "app_users"
  add_foreign_key "service_preferences", "service_categories"
  add_foreign_key "service_providers", "service_categories"
  add_foreign_key "subscribe_deals", "app_users"
  add_foreign_key "subscribe_deals", "deals"
  add_foreign_key "telephone_deal_attributes", "deals"
  add_foreign_key "telephone_service_preferences", "service_preferences"
  add_foreign_key "trending_deals", "deals"
end
