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

ActiveRecord::Schema.define(version: 20170318092511) do

  create_table "band_likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "band_id", null: false
    t.index ["band_id"], name: "index_band_likes_on_band_id"
    t.index ["user_id", "band_id"], name: "index_band_likes_on_user_id_and_band_id", unique: true
    t.index ["user_id"], name: "index_band_likes_on_user_id"
  end

  create_table "bands", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "provider",     null: false
    t.string   "provider_id",  null: false
    t.string   "thumbnail"
    t.string   "external_url"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["name"], name: "index_bands_on_name", unique: true
    t.index ["provider", "provider_id"], name: "index_bands_on_provider_and_provider_id", unique: true
    t.index ["user_id"], name: "index_bands_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.text     "genre",      null: false
    t.integer  "band_id",    null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_genres_on_band_id"
    t.index ["user_id"], name: "index_genres_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
