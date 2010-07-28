class MiniTopic < ActiveRecord::Base

  validates_presence_of :name

  named_scope :within, lambda {|from, to| {:conditions => ["created_at > ? AND created_at < ?", from, to]}}

  serialize :nodes, Array

  def freq_within from, to
    len = nodes.size
    from_node = nil
    to_node = nil
    nodes.each_with_index do |node, i|
      if to_node.nil? and nodes[len - i - 1][:created_at] < to
        to_node = nodes[len - i - 1]
      end
      if from_node.nil? and nodes[len -i - 1][:created_at] < from
        from_node = nodes[len -i - 1]
      end
    end
    (to_node.nil? ? 0 : to_node[:freq]) - (from_node.nil? ? 0 : from_node[:freq])
  end

  def self.hot from, to
    MiniTopic.all.map{|t| [t.freq_within(from, to), t]}.sort{|a, b| b[0] <=> a[0]}
  end

  def add_node freq, time
    if nodes.blank?
      self.nodes = [{:freq => freq, :created_at => time}]
    else
      self.nodes << {:freq => freq, :created_at => time}
    end
    self.freq = freq
    self.save
  end

end
