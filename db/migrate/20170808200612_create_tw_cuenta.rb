class CreateTwCuenta < ActiveRecord::Migration
  def change
    create_table :tw_cuenta do |t|
      t.string :name
      t.string :screen_name
      t.integer :estado_id, :default => 1
      t.integer :id_bot
      t.string :id_str
      t.string :location
      t.string :profile_location
      t.string :description
      t.string :url
      t.string :expanded_url
      t.string :display_url
      t.boolean :protected
      t.integer :friends_count
      t.integer :listed_count
      t.integer :followers_count
      t.string :created_at_perfil
      t.string :datetime
      t.integer :favourites_count
      t.integer :utc_offset
      t.string :time_zone
      t.boolean :geo_enabled
      t.boolean :verified
      t.integer :statuses_count
      t.string :lang
      t.string :text
      t.boolean :truncated
      t.string :geo
      t.string :coordinates
      t.string :place
      t.string :contributors
      t.boolean :is_quote_status
      t.integer :retweet_count
      t.integer :favorite_count
      t.boolean :favorited
      t.boolean :retweeted
      t.boolean :contributors_enabled
      t.boolean :is_translator
      t.boolean :is_translation_enabled
      t.string :profile_background_color
      t.string :profile_background_image_url
      t.string :profile_background_image_url_https
      t.boolean :profile_background_tile
      t.string :profile_image_url
      t.string :profile_image_url_https
      t.string :profile_banner_url
      t.string :profile_link_color
      t.string :profile_sidebar_border_color
      t.string :profile_sidebar_fill_color
      t.string :profile_text_color
      t.boolean :profile_use_background_image
      t.boolean :has_extended_profile
      t.boolean :default_profile
      t.boolean :default_profile_image
      t.string :translator_type

      t.timestamps null: false
    end
  end
end
