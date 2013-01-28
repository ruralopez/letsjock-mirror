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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130128194134) do

  create_table "competitions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "event_id"
    t.string   "name"
    t.datetime "init"
    t.datetime "end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "competition_id"
    t.integer  "recognition_id"
    t.integer  "result_id"
    t.integer  "team_id"
    t.integer  "train_id"
    t.integer  "sport_id"
    t.string   "url"
    t.string   "title"
    t.string   "comment"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "recognitions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "competition_id"
    t.integer  "team_id"
    t.string   "description"
    t.datetime "date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "results", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "competition_id"
    t.integer  "team_id"
    t.integer  "value"
    t.string   "var"
    t.string   "description"
    t.datetime "date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "sports", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "fullpath"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.string   "name"
    t.datetime "init"
    t.datetime "end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "trains", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "team_id"
    t.integer  "trainer_id"
    t.string   "name"
    t.datetime "init"
    t.datetime "end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_sports", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "sport_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_sports", ["user_id", "sport_id"], :name => "index_user_sports_on_user_id_and_sport_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "lastname"
    t.string   "email"
    t.string   "password_digest"
    t.string   "gender"
    t.datetime "birth"
    t.string   "citybirth"
    t.string   "country"
    t.integer  "phone"
    t.string   "resume"
    t.integer  "height"
    t.integer  "weight"
    t.string   "remember_token"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "competition_id"
    t.integer  "recognition_id"
    t.integer  "result_id"
    t.integer  "team_id"
    t.integer  "train_id"
    t.integer  "sport_id"
    t.string   "url"
    t.string   "title"
    t.string   "comment"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
