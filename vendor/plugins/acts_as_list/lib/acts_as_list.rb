module ActsAsList

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
	
		def acts_as_list opts

			cattr_accessor :list_opts
	
			self.list_opts = {:circular => true}.merge(opts)

			extend ActsAsList::SingletonMethods

			include ActsAsList::InstanceMethods

      named_scope :next, lambda {|current| current.next_cond}

      named_scope :prev, lambda {|current| current.prev_cond}
		end

	end

	module SingletonMethods

    def next current
    puts current.next_cond
      self.first(current.next_cond)
    end

    def prev current
      self.first(current.prev_cond)
    end

	end

	module InstanceMethods

    def next_cond
      order_name = self.class.list_opts[:order]
      order = send(order_name)
      conditions = list_cond
      if conditions.blank?
        {:conditions => ["#{order_name} > ?", order], :limit => 1, :order => "#{order_name} ASC"}
      else
        {:conditions => ["#{conditions} AND #{order_name} > ?", order], :limit => 1, :order => "#{order_name} ASC"}
      end    
    end
=begin
		def next my_cond={}
      order_name = self.class.list_opts[:order]
      cond_sql = next_cond
      my_cond_sql = self.class.send(:sanitize_sql_for_conditions, my_cond)
      if !my_cond_sql.blank?
        cond_sql = cond_sql.insert(0, "(#{cond_sql.shift}) AND (#{my_cond_sql})")
      end
      
      @next_in_list = self.class.first(:conditions => cond_sql, :order => "#{order_name} ASC")
      
      if @next_in_list.blank? and self.class.list_opts[:circular]
        @next_in_list = first(my_cond)
      end

      @next_in_list
		end
=end
    def prev_cond
      order_name = self.class.list_opts[:order]
      order = send(order_name)
      conditions = list_cond
      if conditions.blank?
        {:conditions => ["#{order_name} < ?", order], :limit => 1, :order => "#{order_name} DESC"}
      else
        {:conditions => ["#{conditions} AND #{order_name} < ?", order], :limit => 1, :order => "#{order_name} DESC"}
      end
    end
=begin
		def prev my_cond={}
      order_name = self.class.list_opts[:order]
      cond_sql = prev_cond
      my_cond_sql = self.class.send(:sanitize_sql_for_conditions, my_cond)
      if !my_cond_sql.blank?
        cond_sql = cond_sql.insert(0, "(#{cond_sql.shift}) AND (#{my_cond_sql})")
      end

      @prev_in_list = self.class.first(:conditions => cond_sql, :order => "#{order_name} DESC")
      
      if @prev_in_list.blank? and self.class.list_opts[:circular]
        @prev_in_list = last(my_cond)
      end

      @prev_in_list
		end

  protected

    def first my_cond={}
      order_name = self.class.list_opts[:order]
      my_cond_sql = self.class.send(:sanitize_sql_for_conditions, my_cond)
      cond_sql = list_cond
      if !my_cond_sql.blank?
        cond_sql = "#{cond_sql} AND (#{my_cond_sql})"
      end
      @first_in_list ||= self.class.first(:conditions => cond_sql, :order => "#{order_name} ASC")
    end

    def last my_cond={}
      order_name = self.class.list_opts[:order]
      my_cond_sql = self.class.send(:sanitize_sql_for_conditions, my_cond)
      cond_sql = list_cond
      if !my_cond_sql.blank?
        cond_sql = "#{cond_sql} AND (#{my_cond_sql})"
      end
      @last_in_list ||= self.class.find(:first, :conditions => cond_sql, :order => "#{order_name} DESC")
    end
=end

  protected

    def list_cond
      opts = self.class.list_opts
      scope = opts[:scope]
      cond = opts[:conditions]
      
      if scope
        scope_value = send(scope)
        if cond
          "(#{scope} = #{scope_value}) AND (#{self.class.send(:sanitize_sql_for_conditions, cond)})"
        else
          "(#{scope} = #{scope_value})"
        end
      else
        if cond
          "(#{self.class.send(:sanitize_sql_for_conditions, cond)})"
        else
          ""
        end
      end
    end

	end

end

ActiveRecord::Base.send(:include, ActsAsList)
