class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :tag_topics do |t|
      t.string :tag_name, null: false
      t.timestamps
    end

    create_table :taggings do |t|
      t.integer :tag_id, null: false
      t.integer :short_url_id, null: false
      t.timestamps
    end

    add_index :tag_topics, :tag_name
  end
end
