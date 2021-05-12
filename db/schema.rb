# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_12_090501) do

  create_table "airplanes", force: :cascade do |t|
    t.string "reference", null: false
    t.string "model", null: false
    t.integer "max_passengers", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "flight_executions", force: :cascade do |t|
    t.integer "airplane_id"
    t.integer "flight_id"
    t.integer "passengers_count", default: 0, null: false
    t.datetime "start_time", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["airplane_id"], name: "index_flight_executions_on_airplane_id"
    t.index ["flight_id"], name: "index_flight_executions_on_flight_id"
    t.index ["start_time"], name: "index_flight_executions_on_start_time"
  end

  create_table "flights", force: :cascade do |t|
    t.string "from_city", null: false
    t.string "to_city", null: false
    t.integer "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_city", "to_city"], name: "index_flights_on_from_city_and_to_city", unique: true
  end

  create_table "passengers", force: :cascade do |t|
    t.integer "flight_execution_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["flight_execution_id"], name: "index_passengers_on_flight_execution_id"
    t.index ["user_id"], name: "index_passengers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_users_on_token", unique: true
  end

end
