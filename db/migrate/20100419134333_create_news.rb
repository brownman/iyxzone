class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.integer :game_id
      t.integer :poster_id
      t.string :news_type
      t.string :origin_address
      t.string :title
      t.text :data
      t.text :data_abstract
      t.string :video_url
      t.string :thumbnail_url
      t.string :embed_html
      t.integer :comments_count, :default => 0
      t.integer :viewings_count, :default => 0
      t.integer :sharings_count, :default => 0
      t.integer :digs_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
