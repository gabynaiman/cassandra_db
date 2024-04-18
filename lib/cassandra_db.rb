require 'cassandra'
require 'json'
require 'logger'

module CassandraDB

  DEFAULT_KEYSPACE = 'system'.freeze

  DEFAULT_REPLICATION = {
    class: 'SimpleStrategy',
    replication_factor: 1
  }.freeze

  def self.connect(options={})
    Database.new options
  end

end

require_relative 'cassandra_db/version'
require_relative 'cassandra_db/database'
require_relative 'cassandra_db/dataset'
require_relative 'cassandra_db/statements'
require_relative 'cassandra_db/query_condition'