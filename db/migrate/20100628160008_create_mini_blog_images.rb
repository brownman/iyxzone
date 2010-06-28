class CreateMiniBlogImages < ActiveRecord::Migration
  def self.up
    create_table :mini_blog_images do |t|
      t.integer :mini_blog_id
      # attachment_fu fields
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end

  def self.down
    drop_table :mini_blog_images
  end
end
