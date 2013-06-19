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

ActiveRecord::Schema.define(:version => 20130619170306) do

  create_table "activities", :force => true do |t|
    t.integer  "publisher_id"
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "photo_id"
    t.integer  "video_id"
    t.string   "act_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "competitions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "event_id"
    t.integer  "team_id"
    t.integer  "work_id"
    t.string   "team_name"
    t.string   "name"
    t.date     "init"
    t.date     "end"
    t.boolean  "as_athlete"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "organizer"
    t.string   "place"
  end

  create_table "countries", :force => true do |t|
    t.string "iso"
    t.string "name"
  end

  create_table "educations", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "location"
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "degree"
    t.date     "init"
    t.date     "end"
    t.integer  "rank"
    t.string   "career"
    t.string   "gda"
    t.string   "ncaa"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_admins", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_admins", ["user_id", "event_id"], :name => "index_event_admins_on_user_id_and_event_id", :unique => true

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.datetime "date"
    t.string   "description"
    t.string   "name"
    t.string   "place"
    t.string   "imageurl"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "lat"
    t.string   "lon"
    t.datetime "date_end"
  end

  create_table "exams", :force => true do |t|
    t.string   "name"
    t.string   "iso"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "object_id",   :null => false
    t.string   "object_type", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "likes", ["user_id", "object_id", "object_type"], :name => "index_likes_on_user_id_and_object_id_and_object_type", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "receiver_id"
    t.string   "content"
    t.boolean  "read"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user2_id"
    t.integer  "event_id"
    t.boolean  "read"
    t.string   "not_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "outcomes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exam_id"
    t.string   "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.text     "url"
    t.string   "title"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "tags"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "publishers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "pub_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "recognitions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "competition_id"
    t.integer  "team_id"
    t.integer  "work_id"
    t.string   "awarded_by"
    t.string   "description"
    t.date     "date"
    t.boolean  "as_athlete"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "results", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "competition_id"
    t.integer  "team_id"
    t.integer  "work_id"
    t.string   "position"
    t.string   "value"
    t.string   "var"
    t.date     "date"
    t.boolean  "as_athlete"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "category"
    t.boolean  "best_mark"
  end

  create_table "sponsors_events", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id",   :null => false
    t.integer  "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sports", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "fullpath"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "states", :force => true do |t|
    t.string  "iso"
    t.string  "name"
    t.integer "country_id"
  end

  create_table "stats", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.text     "info"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "publisher_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tags", :force => true do |t|
    t.integer  "id1"
    t.integer  "id2"
    t.string   "type1"
    t.string   "type2"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "work_id"
    t.string   "name"
    t.string   "category"
    t.date     "init"
    t.date     "end"
    t.boolean  "as_athlete"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "localization"
  end

  create_table "trainees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.string   "name"
    t.integer  "trainee_id"
    t.integer  "team_id"
    t.integer  "work_id"
    t.date     "init"
    t.date     "end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "trains", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "team_id"
    t.integer  "trainer_id"
    t.string   "name"
    t.date     "init"
    t.date     "end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_admins", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "admin_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_admins", ["user_id", "admin_id"], :name => "index_user_admins_on_user_id_and_admin_id", :unique => true

  create_table "user_events", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_events", ["user_id", "event_id"], :name => "index_user_events_on_user_id_and_event_id", :unique => true

  create_table "user_sports", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "sport_id",   :null => false
    t.string   "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "init"
    t.date     "end"
  end

  add_index "user_sports", ["user_id", "sport_id"], :name => "index_user_sports_on_user_id_and_sport_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "lastname"
    t.string   "email"
    t.string   "password_digest"
    t.string   "profilephotourl"
    t.string   "gender"
    t.date     "birth"
    t.string   "citybirth"
    t.string   "country"
    t.integer  "phone"
    t.text     "resume"
    t.integer  "height"
    t.integer  "weight"
    t.string   "remember_token"
    t.string   "email_token"
    t.boolean  "authentic_email"
    t.boolean  "isSponsor"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "preferences"
    t.string   "address"
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
    t.integer  "trainee_id"
    t.integer  "work_id"
    t.text     "url"
    t.string   "title"
    t.string   "comment"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "works", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.string   "company"
    t.string   "role"
    t.integer  "country_id"
    t.string   "location"
    t.date     "init"
    t.date     "end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
