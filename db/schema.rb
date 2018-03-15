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

ActiveRecord::Schema.define(version: 20180315113720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "place"
    t.date "date", null: false
    t.time "time"
    t.text "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.bigint "tweet_id"
  end

  create_table "raw_tweets", force: :cascade do |t|
    t.bigint "tweet_id"
    t.text "full_text"
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_checked", default: false, null: false
    t.datetime "tweet_posted_at"
    t.boolean "is_valid", default: false, null: false
    t.boolean "is_processed", default: false, null: false
    t.string "username", null: false
    t.string "place"
    t.index ["tweet_id"], name: "index_raw_tweets_on_tweet_id", unique: true
  end

  create_table "twitter_accounts", force: :cascade do |t|
    t.string "twitter_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twitter_name"], name: "index_twitter_accounts_on_twitter_name", unique: true
  end

end
