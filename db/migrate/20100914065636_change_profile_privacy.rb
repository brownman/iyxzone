class ChangeProfilePrivacy < ActiveRecord::Migration
  def self.up
=begin
    step = 2000
    count = User.count
    i = 0
    while (i * step) < count
      User.limit(step).offset(i * step).all.each do |u|
        s = u.privacy_setting
        s.update_attributes :profile => 1
      end
      puts "update #{step}"
      i = i + 1
    end
=end
  end

  def self.down
  end
end
