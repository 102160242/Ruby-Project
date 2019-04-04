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

ActiveRecord::Schema.define(version: 2019_04_04_104133) do

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.text "answer_content"
    t.boolean "right_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers_questions", id: false, force: :cascade do |t|
    t.integer "answer_id"
    t.integer "question_id"
    t.index ["answer_id", "question_id"], name: "index_answers_questions_on_answer_id_and_question_id", unique: true
    t.index ["answer_id"], name: "index_answers_questions_on_answer_id"
    t.index ["question_id"], name: "index_answers_questions_on_question_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_tests", id: false, force: :cascade do |t|
    t.integer "test_id"
    t.integer "category_id"
    t.index ["category_id"], name: "index_categories_tests_on_category_id"
    t.index ["test_id", "category_id"], name: "index_categories_tests_on_test_id_and_category_id", unique: true
    t.index ["test_id"], name: "index_categories_tests_on_test_id"
  end

  create_table "categories_words", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "word_id"
    t.index ["category_id"], name: "index_categories_words_on_category_id"
    t.index ["word_id"], name: "index_categories_words_on_word_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "question_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions_tests", id: false, force: :cascade do |t|
    t.integer "question_id"
    t.integer "test_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "avatar"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_words", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "word_id"
    t.index ["user_id"], name: "index_users_words_on_user_id"
    t.index ["word_id"], name: "index_users_words_on_word_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "word"
    t.string "meaning"
    t.integer "word_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
