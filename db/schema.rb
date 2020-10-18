# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_14_133838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "messages", force: :cascade do |t|
    t.string "to_number"
    t.string "message"
    t.string "callback_url"
    t.uuid "sent_message_id"
    t.string "status"
    t.boolean "queued", default: false
    t.string "code"
    t.integer "provider_id"
    t.datetime "sent_time"
    t.datetime "response_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "send_url"
    t.decimal "percentage_used"
    t.decimal "actual_percentage_used"
    t.decimal "percentage_failed"
    t.integer "count", default: 0
    t.integer "failed_count", default: 0
    t.integer "attempts", default: 0
    t.integer "total_messages_sent"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
