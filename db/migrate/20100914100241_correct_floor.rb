class CorrectFloor < ActiveRecord::Migration
  def self.up
    Topic.all.each do |t|
      t.posts.each_with_index do |p, i|
        p.update_attributes :floor => (i+1)
      end
    end
  end

  def self.down
  end
end
