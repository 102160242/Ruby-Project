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

ActiveRecord::Schema.define(version: 2019_04_09_043057) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.text "answer_content"
    t.boolean "right_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_words", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "word_id"
    t.index ["category_id", "word_id"], name: "index_categories_words_on_category_id_and_word_id", unique: true
    t.index ["category_id"], name: "index_categories_words_on_category_id"
    t.index ["word_id"], name: "index_categories_words_on_word_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "question_content"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions_tests", id: false, force: :cascade do |t|
    t.integer "question_id"
    t.integer "test_id"
    t.integer "chosen_answer_id"
    t.index ["question_id"], name: "index_questions_tests_on_question_id"
    t.index ["test_id", "question_id"], name: "index_questions_tests_on_test_id_and_question_id", unique: true
    t.index ["test_id"], name: "index_questions_tests_on_test_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "tests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_words", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "word_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "word_id"], name: "index_users_words_on_user_id_and_word_id", unique: true
    t.index ["user_id"], name: "index_users_words_on_user_id"
    t.index ["word_id"], name: "index_users_words_on_word_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "word"
    t.string "ipa"
    t.string "meaning"
    t.integer "word_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
