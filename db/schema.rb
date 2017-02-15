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

ActiveRecord::Schema.define(version: 20170214055150) do

  create_table "brands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
  end

  create_table "consolidate_lines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "request_id"
    t.integer "type_id"
    t.integer "product_id"
    t.integer "qty"
    t.integer "unit_id"
    t.integer "consolidate_id"
    t.string  "specification"
  end

  create_table "consolidates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "department_id"
    t.integer  "officer_id"
    t.datetime "group_head_approve"
    t.integer  "received_by"
    t.datetime "ppmd_head_approve"
    t.string   "purpose"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "status"
    t.integer  "inspected_by"
    t.datetime "inspected_date"
    t.string   "ConsNum"
  end

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.integer "group_id"
  end

  create_table "designations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
  end

  create_table "officers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "department_id"
    t.integer "designation_id"
  end

  create_table "order_lines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "type_id"
    t.integer "product_id"
    t.string  "description"
    t.integer "qty"
    t.integer "unit_id"
    t.integer "unit_price"
    t.integer "amount"
    t.integer "consolidate_id"
    t.integer "order_id"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "PONumber"
    t.string   "terms"
    t.date     "delivery_date"
    t.integer  "supplier_id"
    t.string   "total_amount"
    t.string   "user_id"
    t.string   "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.integer "type_id"
  end

  create_table "request_lines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "request_id"
    t.integer "type_id"
    t.integer "product_id"
    t.integer "unit_id"
    t.integer "qty"
  end

  create_table "requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "date_created"
    t.integer  "officer_id"
    t.integer  "department_id"
    t.string   "reason"
    t.string   "status"
    t.string   "RISNum"
  end

  create_table "suppliers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "address"
    t.string   "web"
    t.string   "email"
    t.string   "tel"
    t.string   "tin"
    t.string   "fax"
    t.string   "representative"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.integer "category_id"
  end

  create_table "units", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "empname"
    t.string  "email"
    t.string  "address"
    t.string  "contact_number"
    t.integer "department_id"
    t.integer "designation_id"
    t.string  "password_digest"
  end

end
