require 'ferret'
include Ferret

module HasIndex

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods

    def has_index opts={}

      cattr_accessor :index_opts

      self.index_opts = opts

      before_create :create_index

      before_update :update_index

      before_destroy :destroy_index   

      include HasIndex::InstanceMethods

      extend HasIndex::SingletonMethods
 
    end

  end

  module InstanceMethods

    def create_index
      self.index_state = 0
    end

    def update_index
      if self.index_state == 1 and index_columns_changed?
        DeletedIndex.create :model_name => self.class.name, :doc_id => self.id
        self.index_state = 0
      end
    end

    def destroy_index
      if self.index_state == 1
        DeletedIndex.create :model_name => self.class.name, :doc_id => self.id
      end
    end

    #
    # 被索引了？？
    #
    def indexed?
      self.index_state == 1
    end

  protected

    def index_columns_changed?
      changed = false
      self.class.index_opts[:select_fields].each do |column|
        changed ||= eval("self.#{column}_changed?")
      end
      changed
    end 

  end

  module SingletonMethods

    # some methods about index
   
    def deleted_indexes
      DeletedIndex.all(:conditions => {:model_name => self.name})
    end

    def index_dir
      "#{RAILS_ROOT}/index/#{self.name.underscore}"
    end
    
    def background_indexer
      if @background_indexer.nil?
        @background_indexer = HasIndex::BackgroundIndexer.new self.name.underscore, self.index_opts
      end
      @background_indexer 
    end

    def build_main_index
      background_indexer.build_main_index
    end

    def build_delta_index
      background_indexer.build_delta_index
    end

    def indexer
      if @indexer.nil?
        @indexer = Ferret::Index::Index.new :path => index_dir, :analyzer => ChineseAnalyzer.new
      end
      @indexer
    end

    # some methods about index snapshot
    def snapshot_manager
      if @snapshot_manager.nil?
        @snapshot_manager = HasIndex::SnapshotManager.new self
      end
      @snapshot_manager
    end

    def make_index_snapshot
      snapshot_manager.make_snapshot
    end

    def clean_index_snapshots_before ago
      snapshot_manager.clean_snapshots_before ago
    end

    def get_index_snapshot_before time 
      snapshot_manager.get_snapshot_before time
    end  

    # 这个是和will_paginate兼容的，比那个煞笔acts_as_ferret强多了
    def search *args
      fql = args.first
      opts = args.extract_options!

      # parse query string
      query = ""
      if fql.is_a? Hash
        query = []
        fql.each do |key, val|
          query << "#{key}:(#{val.split(/\s*~\s*/).map{|a| "(#{a.split(/\s+/).join(" AND ")})"}.join(" OR ")})"
        end
        query = query.join(" AND ")
      elsif query.is_a? String
        query = fql.split(/\s*~\s*/).map{|a| "(#{a.split(/\s+/).join(" AND ")})"}.join(" OR ")
      end

      # parse per page and page
      per_page = opts.delete(:per_page)
      page = opts.delete(:page)
      page = page.nil? ? 1 : page.to_i
      if per_page.nil?
        opts[:limit] = :all
      else
        opts[:limit] = per_page.to_i
        opts[:offset] = (page - 1) * per_page.to_i
      end
      
      # construct sort if necessary
      sort_fields = []
      sort_str = opts.delete(:sort) || ""
      sanitized_sort_str = []
      sort_str.split(/\s*,\s*/).each do |str|
        splits = str.split(/\s+/)
        name = splits.first
        order = splits[1].nil? ? 'asc' : splits[1].downcase
        columns = self.columns.select{|c| c.name == name}
        if !columns.blank?
          column = columns.first
          if column.type == :datetime
            sort_fields << Ferret::Search::SortField.new(name, :type => :byte, :reverse => (order == "desc"))
          elsif column.type == :string or column.type == :text
            sort_fields << Ferret::Search::SortField.new(name, :type => :string, :reverse => (order == "desc"))
          elsif column.type == :integer
            sort_fields << Ferret::Search::SortField.new(name, :type => :integer, :reverse => (order == "desc"))
          elsif column.type == :float
            sort_fields << Ferret::Search::SortField.new(name, :type => :float, :reverse => (order == "desc"))
          else
            sort_fields << Ferret::Search::SortField.new(name, :type => :auto, :reverse => (order == "desc"))
          end
          sanitized_sort_str << "#{name} #{order}"
        end
      end
      if !sort_fields.blank?
        sort = Ferret::Search::Sort.new(sort_fields)
        opts[:sort] = sort
      end
      
			# 目前默认field_infos里一定要有id      
      docs = indexer.search query, opts
      ids = docs.hits.map{|hit| indexer.reader.get_document(hit.doc)[:id]}
      records = []
      if sort_fields.blank?
        records = self.match(:id => ids).all
      else
        records = self.order(sanitized_sort_str.join(",")).match(:id => ids).all
      end

      # 只要你指定了per_page我就转换为will paginate的分页
      if page and per_page
        WillPaginate::Collection.create(page, per_page, docs.total_hits) do |pager|
          pager.replace records.to_a
        end
      else
        records
      end
    end

  end

end

ActiveRecord::Base.send(:include, HasIndex)

