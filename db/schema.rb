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

ActiveRecord::Schema.define(:version => 20101205150817) do

  create_table "companies", :force => true do |t|
    t.string   "name",             :null => false
    t.string   "email_originator", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.integer  "company_id",    :null => false
    t.string   "firstName",     :null => false
    t.string   "lastName",      :null => false
    t.string   "landlinePhone"
    t.string   "mobilePhone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "meetings", :force => true do |t|
    t.integer  "company_id",  :null => false
    t.integer  "customer_id", :null => false
    t.integer  "operator_id"
    t.datetime "start",       :null => false
    t.datetime "end",         :null => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "alert_sent"
  end

  create_table "operators", :force => true do |t|
    t.integer  "company_id"
    t.string   "username",                                  :null => false
    t.string   "crypted_password",                          :null => false
    t.string   "password_salt",                             :null => false
    t.string   "persistence_token"
    t.string   "first_name",                                :null => false
    t.string   "last_name",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",              :default => "operator", :null => false
  end

end
