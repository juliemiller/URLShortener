class CreateShortenedUrLs < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :short_url, null: false, unique: true
      t.string :long_url, null: false
      t.string :user_id, null: false
      t.timestamps
    end

    add_index :shortened_urls, :user_id
    add_index :shortened_urls, :short_url
  end
end
