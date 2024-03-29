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

ActiveRecord::Schema.define(:version => 20120616171829) do

  create_table "attachments", :force => true do |t|
    t.string   "file"
    t.integer  "attachable_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "attachable_type"
    t.integer  "downloads",       :default => 0
  end

  add_index "attachments", ["attachable_id"], :name => "index_attachments_on_attachable_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "favorites", ["resource_id"], :name => "index_favorites_on_resource_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "first_users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "first_users", ["email"], :name => "index_first_users_on_email", :unique => true

  create_table "grades", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quotes", :force => true do |t|
    t.string   "message"
    t.string   "author"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "resource_grades", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "grade_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "resource_grades", ["grade_id"], :name => "index_resource_grades_on_grade_id"
  add_index "resource_grades", ["resource_id"], :name => "index_resource_grades_on_resource_id"

  create_table "resource_topics", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "topic_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "resources", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "title"
    t.integer  "user_id"
    t.integer  "views",             :default => 0
    t.string   "extracted_content"
    t.integer  "grade_id"
  end

  add_index "resources", ["grade_id"], :name => "index_resources_on_grade_id"
  add_index "resources", ["user_id"], :name => "index_resources_on_user_id"
  add_index "resources", ["views"], :name => "index_resources_on_views"

  create_table "test_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "test_users", ["email"], :name => "index_test_users_on_email", :unique => true
  add_index "test_users", ["reset_password_token"], :name => "index_test_users_on_reset_password_token", :unique => true

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "topics", ["name"], :name => "index_topics_on_name", :unique => true

  create_table "user_attachment_downloads", :force => true do |t|
    t.integer  "user_id"
    t.integer  "attachment_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_attachment_downloads", ["attachment_id"], :name => "index_user_attachment_downloads_on_attachment_id"
  add_index "user_attachment_downloads", ["user_id"], :name => "index_user_attachment_downloads_on_user_id"

  create_table "user_queries", :force => true do |t|
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_resource_views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_resource_views", ["resource_id"], :name => "index_user_resource_views_on_resource_id"
  add_index "user_resource_views", ["user_id"], :name => "index_user_resource_views_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "screen_name"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "confirmation_token"
    t.string   "unconfirmed_email"
    t.string   "created_ip"
    t.integer  "status",                 :default => 0
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "downloads",              :default => 0
  end

  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["created_ip"], :name => "index_users_on_created_ip"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["screen_name"], :name => "index_users_on_screen_name", :unique => true
  add_index "users", ["status"], :name => "index_users_on_status"

end
