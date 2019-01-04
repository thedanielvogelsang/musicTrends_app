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

ActiveRecord::Schema.define(version: 2019_01_04_195240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "keyword_taggings", force: :cascade do |t|
    t.bigint "keyword_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_keyword_taggings_on_keyword_id"
    t.index ["tag_id"], name: "index_keyword_taggings_on_tag_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "phrase"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.string "text"
    t.integer "search_type", default: 0
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "song_searches", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "search_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count"
    t.index ["search_id"], name: "index_song_searches_on_search_id"
    t.index ["song_id"], name: "index_song_searches_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.string "artist_name"
    t.integer "artist_id"
    t.integer "annotation_ct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "context"
    t.string "key_words", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "keyword_taggings", "keywords"
  add_foreign_key "keyword_taggings", "tags"
  add_foreign_key "song_searches", "searches"
  add_foreign_key "song_searches", "songs"
end
