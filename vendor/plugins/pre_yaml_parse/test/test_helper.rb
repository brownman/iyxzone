#ENV['RAILS_ENV'] = 'test'
#ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
#RAILS_ROOT = File.dirname(__FILE__) + '/../../../..'

#require 'test/unit'
#require File.expand_path(File.join(ENV['RAILS_ROOT'],'config/environment'))
=begin
def load_schema
	config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
	ActiveRecord::Baswe.logger = Logger.new(File.dirname(__FILE__) + debug.log)
	db_adapter = ENV['DB']
	db_adapter ||= 'mysql'
	
	ActiveRecord::Base.establish_connection(config[db_adapter])
	load(File.dirname(__FILE__) + "/schema.rb")
	require File.dirname(__FILE__) + "/../rails/init.rb"

end
=end

require 'rubygems'
require 'active_support'
require 'active_support/test_case'
