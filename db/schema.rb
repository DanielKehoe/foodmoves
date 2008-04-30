# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 115) do

  create_table "addresses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addressable_id",                                   :default => 0,  :null => false
    t.string   "addressable_type",                                 :default => "", :null => false
    t.string   "tag_for_address"
    t.decimal  "lat",              :precision => 15, :scale => 10
    t.decimal  "lng",              :precision => 15, :scale => 10
    t.integer  "admin_area_id"
    t.string   "locality"
    t.string   "thoroughfare"
    t.string   "postal_code"
    t.integer  "region_id"
    t.integer  "country_id"
  end

  add_index "addresses", ["thoroughfare"], :name => "index_addresses_on_thoroughfare"

  create_table "affiliations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",                       :default => false
    t.datetime "reviewed_at"
    t.string   "called_by",        :limit => 80
    t.string   "talked_to",        :limit => 80
    t.text     "notes"
    t.integer  "organization_id"
    t.boolean  "approved_to_buy"
    t.boolean  "approved_to_sell"
  end

  create_table "answers", :force => true do |t|
    t.decimal  "sort_order", :precision => 8, :scale => 2, :default => 50.0
    t.integer  "user_id"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "topic"
    t.string   "question"
    t.text     "answer"
    t.boolean  "approved",                                 :default => false
  end

  create_table "assets", :force => true do |t|
    t.string   "filename"
    t.integer  "width"
    t.integer  "height"
    t.string   "content_type"
    t.integer  "size"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "thumbnail"
    t.integer  "parent_id"
    t.integer  "created_by_id"
  end

  create_table "auctions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date_to_start"
    t.datetime "date_to_end"
    t.integer  "seller_id"
    t.integer  "address_id"
    t.decimal  "lat",               :precision => 15, :scale => 10, :default => 0.0
    t.decimal  "lng",               :precision => 15, :scale => 10, :default => 0.0
    t.decimal  "reserve_price",     :precision => 10, :scale => 2,  :default => 0.0
    t.decimal  "minimum_bid",       :precision => 10, :scale => 2,  :default => 0.0
    t.decimal  "bid_increment",     :precision => 10, :scale => 2,  :default => 0.0
    t.integer  "how_many_bids",                                     :default => 0
    t.datetime "date_last_bid"
    t.decimal  "current_bid",       :precision => 10, :scale => 2,  :default => 0.0
    t.boolean  "closed",                                            :default => false
    t.integer  "buyer_id"
    t.integer  "color_id"
    t.integer  "condition_id"
    t.integer  "food_id"
    t.integer  "grown_id"
    t.integer  "pack_id"
    t.integer  "per_case_id"
    t.integer  "quality_id"
    t.integer  "size_id"
    t.integer  "weight_id"
    t.string   "shipping_from"
    t.string   "description"
    t.boolean  "for_export"
    t.integer  "origin_region_id"
    t.integer  "origin_country_id"
    t.integer  "plu"
    t.integer  "quantity"
    t.boolean  "allow_partial"
    t.integer  "min_quantity"
    t.integer  "feedback_id"
    t.integer  "creditworth_id"
    t.integer  "timeliness_id"
    t.integer  "integrity_id"
    t.boolean  "plu_stickered"
    t.decimal  "temperature",       :precision => 10, :scale => 2,  :default => 0.0
    t.datetime "date_to_pickup"
    t.boolean  "celsius"
    t.boolean  "barcoded"
    t.string   "lot_number"
    t.integer  "pickup_limit"
    t.integer  "cases_per_pallet"
    t.integer  "pallets"
    t.boolean  "test_only"
    t.boolean  "organic"
    t.boolean  "fair_trade"
    t.string   "pickup_number"
    t.boolean  "kosher"
    t.decimal  "buy_now_price",     :precision => 10, :scale => 2,  :default => 0.0
    t.integer  "last_bid_id"
    t.boolean  "iced",                                              :default => false
    t.boolean  "premium_service",                                   :default => false
    t.boolean  "bill_me",                                           :default => false
    t.boolean  "discount",                                          :default => false
    t.decimal  "due_foodmoves",     :precision => 10, :scale => 2,  :default => 0.0
    t.datetime "date_paid"
    t.datetime "date_billed"
    t.boolean  "consignment",                                       :default => false
    t.decimal  "sale_total",        :precision => 10, :scale => 2,  :default => 0.0
    t.string   "po_number"
  end

  create_table "auctions_certifications", :id => false, :force => true do |t|
    t.integer "auction_id",       :default => 0, :null => false
    t.integer "certification_id", :default => 0, :null => false
  end

  create_table "auctions_treatments", :id => false, :force => true do |t|
    t.integer "auction_id",   :default => 0, :null => false
    t.integer "treatment_id", :default => 0, :null => false
  end

  create_table "bids", :force => true do |t|
    t.boolean  "closed",                                        :default => false
    t.boolean  "winner",                                        :default => false
    t.integer  "user_id"
    t.integer  "auction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closed_at"
    t.decimal  "amount",         :precision => 10, :scale => 2, :default => 0.0
    t.integer  "quantity",                                      :default => 0
    t.datetime "date_to_end"
    t.datetime "date_to_pickup"
    t.boolean  "buy_now_sale",                                  :default => false
  end

  create_table "bluebook_members", :force => true do |t|
    t.integer  "bluebook_id",          :limit => 6
    t.string   "name",                 :limit => 80
    t.string   "corr_trade_name_1",    :limit => 34
    t.string   "corr_trade_name_2",    :limit => 34
    t.string   "section",              :limit => 1
    t.string   "city",                 :limit => 34
    t.string   "state",                :limit => 30
    t.string   "country",              :limit => 30
    t.string   "county",               :limit => 30
    t.string   "hqbr",                 :limit => 1
    t.integer  "hqbbid",               :limit => 6
    t.string   "mail_address_1",       :limit => 34
    t.string   "mail_address_2",       :limit => 34
    t.string   "mail_city",            :limit => 34
    t.string   "mail_state",           :limit => 30
    t.string   "mail_country",         :limit => 30
    t.string   "mail_postal_code",     :limit => 10
    t.string   "phys_address_1",       :limit => 34
    t.string   "phys_address_2",       :limit => 34
    t.string   "phys_city",            :limit => 34
    t.string   "phys_state",           :limit => 30
    t.string   "phys_country",         :limit => 30
    t.string   "phys_postal_code",     :limit => 10
    t.string   "voice_phone",          :limit => 30
    t.string   "fax",                  :limit => 30
    t.string   "tollfree",             :limit => 30
    t.string   "email",                :limit => 34
    t.string   "website",              :limit => 50
    t.string   "license_type",         :limit => 5
    t.string   "license",              :limit => 8
    t.string   "chainstores",          :limit => 1
    t.string   "volume",               :limit => 6
    t.string   "credit_worth_rating",  :limit => 8
    t.string   "integ_ability_rating", :limit => 8
    t.string   "pay_rating",           :limit => 8
    t.string   "rating_numerals",      :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bluebook_members", ["name"], :name => "bluebook_members_index"

  create_table "call_results", :force => true do |t|
    t.decimal "sort_order",  :precision => 8, :scale => 2, :default => 50.0
    t.string  "name"
    t.string  "description"
  end

  create_table "certifications", :force => true do |t|
    t.string  "name"
    t.string  "url"
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

  create_table "colors", :force => true do |t|
    t.string  "name"
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

  create_table "colors_foods", :id => false, :force => true do |t|
    t.integer "food_id",  :default => 0, :null => false
    t.integer "color_id", :default => 0, :null => false
  end

  create_table "conditions", :force => true do |t|
    t.string  "name"
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name",      :limit => 80
    t.string   "last_name",       :limit => 80
    t.string   "email",           :limit => 80
    t.string   "time_zone",       :limit => 80, :default => "Etc/UTC"
    t.integer  "region_id"
    t.integer  "country_id"
    t.string   "industry_role",   :limit => 80
    t.string   "starts_as",       :limit => 80
    t.string   "created_by",      :limit => 80
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.string   "title"
  end

  create_table "creditworth", :force => true do |t|
    t.integer "sort_order"
    t.string  "description"
  end

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "feedback", :force => true do |t|
    t.integer "sort_order"
    t.string  "description"
  end

  create_table "flag_for_users", :force => true do |t|
    t.string  "name"
    t.decimal "sort_order",  :precision => 8, :scale => 2
    t.string  "color"
    t.string  "description"
  end

  create_table "foods", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "children_count",                               :default => 0,    :null => false
    t.string   "name",                                         :default => "",   :null => false
    t.integer  "plu",                                          :default => 0
    t.decimal  "sort_order",     :precision => 8, :scale => 2, :default => 99.0
    t.string   "en_espanol"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "updated_by"
  end

  create_table "foods_growns", :id => false, :force => true do |t|
    t.integer "food_id",  :default => 0, :null => false
    t.integer "grown_id", :default => 0, :null => false
  end

  create_table "foods_packs", :id => false, :force => true do |t|
    t.integer "food_id", :default => 0, :null => false
    t.integer "pack_id", :default => 0, :null => false
  end

  create_table "foods_per_cases", :id => false, :force => true do |t|
    t.integer "food_id",     :default => 0, :null => false
    t.integer "per_case_id", :default => 0, :null => false
  end

  create_table "foods_sizes", :id => false, :force => true do |t|
    t.integer "food_id", :default => 0, :null => false
    t.integer "size_id", :default => 0, :null => false
  end

  add_index "foods_sizes", ["food_id"], :name => "fk_bk_foods"
  add_index "foods_sizes", ["size_id"], :name => "fk_bk_sizes"

  create_table "foods_weights", :id => false, :force => true do |t|
    t.integer "food_id",   :default => 0, :null => false
    t.integer "weight_id", :default => 0, :null => false
  end

  create_table "geographies", :force => true do |t|
    t.integer "parent_id"
    t.integer "children_count"
    t.decimal "sort_order",        :precision => 8,  :scale => 2
    t.boolean "place"
    t.string  "of_type"
    t.string  "label"
    t.decimal "lat",               :precision => 15, :scale => 10
    t.decimal "lng",               :precision => 15, :scale => 10
    t.string  "name"
    t.string  "code"
    t.string  "three_letter_code"
    t.string  "three_digit_code"
    t.string  "phone_code"
    t.string  "currency_code"
    t.string  "currency_name"
    t.integer "admin_by_id"
  end

  create_table "globalize_countries", :force => true do |t|
    t.string "code",                   :limit => 2
    t.string "english_name"
    t.string "date_format"
    t.string "currency_format"
    t.string "currency_code",          :limit => 3
    t.string "thousands_sep",          :limit => 2
    t.string "decimal_sep",            :limit => 2
    t.string "currency_decimal_sep",   :limit => 2
    t.string "number_grouping_scheme"
  end

  add_index "globalize_countries", ["code"], :name => "index_globalize_countries_on_code"

  create_table "globalize_languages", :force => true do |t|
    t.string  "iso_639_1",             :limit => 2
    t.string  "iso_639_2",             :limit => 3
    t.string  "iso_639_3",             :limit => 3
    t.string  "rfc_3066"
    t.string  "english_name"
    t.string  "english_name_locale"
    t.string  "english_name_modifier"
    t.string  "native_name"
    t.string  "native_name_locale"
    t.string  "native_name_modifier"
    t.boolean "macro_language"
    t.string  "direction"
    t.string  "pluralization"
    t.string  "scope",                 :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "index_globalize_languages_on_iso_639_1"
  add_index "globalize_languages", ["iso_639_2"], :name => "index_globalize_languages_on_iso_639_2"
  add_index "globalize_languages", ["iso_639_3"], :name => "index_globalize_languages_on_iso_639_3"
  add_index "globalize_languages", ["rfc_3066"], :name => "index_globalize_languages_on_rfc_3066"

  create_table "globalize_translations", :force => true do |t|
    t.string  "type"
    t.string  "tr_key"
    t.string  "table_name"
    t.integer "item_id"
    t.string  "facet"
    t.integer "language_id"
    t.integer "pluralization_index"
    t.text    "text"
    t.string  "namespace"
  end

  add_index "globalize_translations", ["tr_key", "language_id"], :name => "index_globalize_translations_on_tr_key_and_language_id"
  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"

  create_table "growns", :force => true do |t|
    t.string  "name",                                     :default => "", :null => false
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

  create_table "integrity", :force => true do |t|
    t.integer "sort_order"
    t.string  "description"
  end

  create_table "invitation_codes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.string   "code"
    t.integer  "response_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sent_count",     :default => 0
  end

  create_table "liability_limits", :force => true do |t|
    t.decimal "sort_order",  :precision => 8, :scale => 2
    t.string  "description"
  end

  create_table "organizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "industry_role"
    t.string   "rated_by",                                                          :default => "other"
    t.integer  "bluebook_member_id",  :limit => 6
    t.integer  "created_by"
    t.string   "of_type",                                                           :default => "Organization"
    t.string   "locality",            :limit => 80
    t.integer  "admin_area_id"
    t.integer  "country_id"
    t.string   "admin_area_abbr"
    t.string   "country_name"
    t.integer  "region_id"
    t.string   "email",               :limit => 80
    t.string   "website",             :limit => 80
    t.string   "source",              :limit => 34,                                 :default => "other"
    t.string   "created_by_name"
    t.decimal  "lat",                               :precision => 15, :scale => 10, :default => 0.0
    t.decimal  "lng",                               :precision => 15, :scale => 10, :default => 0.0
    t.string   "person"
    t.string   "thoroughfare"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "call_result",                                                       :default => "not called"
    t.string   "updated_by"
    t.integer  "acct_exec_id"
    t.string   "paca_license",        :limit => 30
    t.string   "bluebook_password",   :limit => 30
    t.integer  "feedback_id"
    t.integer  "creditworth_id"
    t.integer  "timeliness_id"
    t.integer  "integrity_id"
    t.boolean  "needs_review",                                                      :default => false
    t.integer  "liability_limits_id"
    t.boolean  "do_not_contact"
  end

  create_table "packs", :force => true do |t|
    t.string  "name",                                     :default => "", :null => false
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

  create_table "per_cases", :force => true do |t|
    t.string  "name"
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "phonable_id",   :default => 0,  :null => false
    t.string   "phonable_type", :default => "", :null => false
    t.string   "tag_for_phone"
    t.string   "number"
    t.string   "country_code"
    t.string   "locality_code"
    t.string   "local_number"
    t.integer  "region_id"
    t.integer  "country_id"
  end

  add_index "phones", ["number"], :name => "index_phones_on_number"

  create_table "prospects", :force => true do |t|
    t.string   "name",               :limit => 80
    t.string   "industry_role",      :limit => 80
    t.string   "locality",           :limit => 80
    t.integer  "admin_area_id"
    t.integer  "country_id"
    t.string   "admin_area_abbr"
    t.string   "country_name"
    t.integer  "region_id"
    t.string   "email",              :limit => 80
    t.string   "website",            :limit => 80
    t.string   "source",             :limit => 34,                                 :default => "other"
    t.integer  "bluebook_member_id", :limit => 6
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "lat",                              :precision => 15, :scale => 10, :default => 0.0
    t.decimal  "lng",                              :precision => 15, :scale => 10, :default => 0.0
    t.string   "person"
    t.string   "thoroughfare"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "call_result",                                                      :default => "not called"
    t.string   "updated_by"
    t.string   "of_type",                                                          :default => "Prospect"
  end

  create_table "qualities", :force => true do |t|
    t.string  "name"
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

  create_table "roles", :force => true do |t|
    t.string "title"
    t.string "description"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sizes", :force => true do |t|
    t.string  "name",                                     :default => "", :null => false
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

  create_table "survey_questions", :force => true do |t|
    t.string  "of_type"
    t.decimal "sort_order",  :precision => 8, :scale => 2
    t.string  "answer"
    t.integer "responses"
    t.string  "description"
  end

  create_table "tag_for_locations", :force => true do |t|
    t.string  "name"
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "of_type"
  end

  create_table "timeliness", :force => true do |t|
    t.integer "sort_order"
    t.string  "description"
  end

  create_table "tokens", :force => true do |t|
    t.string   "tag"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "month"
    t.string   "year"
    t.string   "region"
    t.string   "country"
    t.string   "admin_area"
    t.string   "locality"
    t.string   "thoroughfare"
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.text     "crypted_number"
    t.string   "last_digits",     :limit => 4
  end

  create_table "treatments", :force => true do |t|
    t.string  "name"
    t.string  "en_espanol"
    t.integer "sort_order"
  end

  create_table "users", :force => true do |t|
    t.string   "of_type"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "visits_count",                            :default => 0
    t.string   "time_zone",                               :default => "Etc/UTC"
    t.string   "permalink"
    t.string   "referred_by"
    t.integer  "parent_id"
    t.string   "invitation_code"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "country"
    t.boolean  "email_confirmed"
    t.integer  "children_count"
    t.string   "industry_role"
    t.integer  "region_id"
    t.integer  "country_id"
    t.string   "starts_as"
    t.string   "first_phone"
    t.string   "how_heard"
    t.integer  "flag_for_user_id"
    t.datetime "invited_again_at"
    t.boolean  "blocked"
    t.boolean  "do_not_contact"
  end

  create_table "watched_locations", :force => true do |t|
    t.string   "user_id"
    t.string   "name"
    t.string   "locality"
    t.integer  "admin_area_id"
    t.integer  "country_id"
    t.integer  "region_id"
    t.decimal  "lat",           :precision => 15, :scale => 10, :default => 0.0
    t.decimal  "lng",           :precision => 15, :scale => 10, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watched_products", :force => true do |t|
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "food_id"
  end

  create_table "weights", :force => true do |t|
    t.string  "name",                                     :default => "", :null => false
    t.decimal "sort_order", :precision => 8, :scale => 2
    t.string  "en_espanol"
  end

end
