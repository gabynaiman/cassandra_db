module CassandraDB
  class Database

    DEFAULTS = {
      keyspace: DEFAULT_KEYSPACE
    }.freeze

    DEFAULT_LOGGER = Logger.new '/dev/null'

    def initialize(options={})
      @options = DEFAULTS.merge(options)
      keyspace = @options.delete :keyspace
      @cluster = Cassandra.cluster @options
      @session = use_keyspace keyspace
    end

    def keyspace
      session.keyspace.to_sym
    end

    def use_keyspace(name)
      @session = cluster.connect name.to_s
    end

    def keyspaces
      cluster.refresh_schema
      cluster.keyspaces.map { |k| k.name.to_sym }.sort
    end

    def tables
      cluster.refresh_schema
      cluster.keyspace(session.keyspace).tables.map { |t| t.name.to_sym }.sort
    end

    def from(table)
      Dataset.new self, table: table
    end
    alias_method :[], :from

    def create_keyspace(name, replication:DEFAULT_REPLICATION, durable_writes:true)
      cql = %Q{
        CREATE KEYSPACE "#{name}"
          WITH REPLICATION = #{JSON.dump(replication).gsub('"', '\'')}
          AND DURABLE_WRITES = #{durable_writes};
      }
      execute cql
    end

    def drop_keyspace(name)
      execute "DROP KEYSPACE \"#{name}\";"
    end

    def execute(cql, options={})
      logger.debug(self.class) { "#{cql} #{options.any? ? options : ''}".strip }
      session.execute cql, options
    end

    def inspect
      "#<#{self.class.name}: options=#{options.inspect} keyspace=#{keyspace.inspect}>"
    end

    private

    attr_reader :cluster, :session, :options

    def logger
      @logger ||= options.fetch(:logger, DEFAULT_LOGGER)
    end

  end
end