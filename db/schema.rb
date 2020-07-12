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

ActiveRecord::Schema.define(version: 2020_07_12_171526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "available_spells", force: :cascade do |t|
    t.bigint "character_specialization_id", null: false
    t.bigint "spell_id", null: false
    t.boolean "counts", default: true
    t.string "note"
    t.index ["character_specialization_id"], name: "index_available_spells_on_character_specialization_id"
    t.index ["spell_id"], name: "index_available_spells_on_spell_id"
  end

  create_table "caster_classes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "caster_classes_spells", id: false, force: :cascade do |t|
    t.bigint "caster_class_id", null: false
    t.bigint "spell_id", null: false
  end

  create_table "character_specializations", force: :cascade do |t|
    t.bigint "character_id"
    t.string "subclass"
    t.string "sub2"
    t.integer "level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "spellcasting_ability_score"
    t.string "character_class"
    t.index ["character_id"], name: "index_character_specializations_on_character_id"
  end

  create_table "characters", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "race"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "spells", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.text "description"
    t.string "casting_time"
    t.string "range"
    t.string "components"
    t.string "duration"
    t.boolean "concentration"
    t.boolean "ritual"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "school"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_spells_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_hash"
    t.string "password_salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_reset_token"
    t.datetime "token_expires_after"
    t.string "authentication_token"
    t.datetime "signed_up_on"
    t.datetime "last_sign_in"
  end

end
