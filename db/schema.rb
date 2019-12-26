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

ActiveRecord::Schema.define(version: 2019_12_26_143338) do

  create_table "bot_ciudades", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "bot_id"
    t.integer "ciudad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bot_ciudads", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "bot_id"
    t.integer "ciudad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bots", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "screen_name"
    t.string "tw_token"
    t.string "tw_secret"
    t.integer "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "siguiendo"
    t.integer "seguidores"
    t.integer "palabra_indice"
    t.integer "palabra_maximo"
    t.integer "ciudad_indice"
    t.integer "cantidad_seguir"
    t.integer "verificar_seguido"
    t.bigint "id_bot"
    t.string "id_str"
    t.string "location"
    t.string "profile_location"
    t.string "description"
    t.string "url"
    t.string "expanded_url"
    t.string "display_url"
    t.boolean "protected"
    t.integer "friends_count"
    t.integer "listed_count"
    t.integer "followers_count"
    t.datetime "created_at_perfil"
    t.integer "favourites_count"
    t.integer "utc_offset"
    t.string "time_zone"
    t.boolean "geo_enabled"
    t.boolean "verified"
    t.integer "statuses_count"
    t.string "lang"
    t.string "text"
    t.boolean "truncated"
    t.string "geo"
    t.string "coordinates"
    t.string "place"
    t.string "contributors"
    t.boolean "is_quote_status"
    t.integer "retweet_count"
    t.integer "favorite_count"
    t.boolean "favorited"
    t.boolean "retweeted"
    t.boolean "contributors_enabled"
    t.boolean "is_translator"
    t.boolean "is_translation_enabled"
    t.string "profile_background_color"
    t.string "profile_background_image_url"
    t.string "profile_background_image_url_https"
    t.boolean "profile_background_tile"
    t.string "profile_image_url"
    t.string "profile_image_url_https"
    t.string "profile_banner_url"
    t.string "profile_link_color"
    t.string "profile_sidebar_border_color"
    t.string "profile_sidebar_fill_color"
    t.string "profile_text_color"
    t.boolean "profile_use_background_image"
    t.boolean "has_extended_profile"
    t.boolean "default_profile"
    t.boolean "default_profile_image"
    t.string "translator_type"
  end

  create_table "ciudads", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.string "longitud"
    t.string "latitud"
    t.integer "km"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follow_registers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "tw_bot"
    t.bigint "tw_follow"
    t.integer "estado_id", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cursor_followers", default: "0"
    t.string "cursor_friends", default: "0"
  end

  create_table "palabras", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "bot_id"
    t.string "palabra"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tw_cuenta", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "screen_name"
    t.integer "estado_id", default: 1
    t.bigint "id_bot"
    t.string "id_str"
    t.string "location"
    t.string "profile_location"
    t.string "description"
    t.string "url"
    t.string "expanded_url"
    t.string "display_url"
    t.boolean "protected"
    t.integer "friends_count"
    t.integer "listed_count"
    t.integer "followers_count"
    t.string "created_at_perfil"
    t.string "datetime"
    t.integer "favourites_count"
    t.integer "utc_offset"
    t.string "time_zone"
    t.boolean "geo_enabled"
    t.boolean "verified"
    t.integer "statuses_count"
    t.string "lang"
    t.string "text"
    t.boolean "truncated"
    t.string "geo"
    t.string "coordinates"
    t.string "place"
    t.string "contributors"
    t.boolean "is_quote_status"
    t.integer "retweet_count"
    t.integer "favorite_count"
    t.boolean "favorited"
    t.boolean "retweeted"
    t.boolean "contributors_enabled"
    t.boolean "is_translator"
    t.boolean "is_translation_enabled"
    t.string "profile_background_color"
    t.string "profile_background_image_url"
    t.string "profile_background_image_url_https"
    t.boolean "profile_background_tile"
    t.string "profile_image_url"
    t.string "profile_image_url_https"
    t.string "profile_banner_url"
    t.string "profile_link_color"
    t.string "profile_sidebar_border_color"
    t.string "profile_sidebar_fill_color"
    t.string "profile_text_color"
    t.boolean "profile_use_background_image"
    t.boolean "has_extended_profile"
    t.boolean "default_profile"
    t.boolean "default_profile_image"
    t.string "translator_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tw_followers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "tw_user_id"
    t.bigint "tw_follower"
    t.integer "estado_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tw_friends", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "tw_user_id"
    t.bigint "tw_friend"
    t.integer "estado_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "bot_id"
    t.string "tw_usuario_id"
    t.string "tw_tweet_id"
    t.string "tw_location"
    t.string "tw_usuario"
    t.string "tw_text"
    t.string "tw_created_at"
    t.integer "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "palabra"
    t.string "ciudad"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

end
