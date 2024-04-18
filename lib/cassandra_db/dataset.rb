module CassandraDB
  class Dataset

    include Enumerable

    def initialize(db, table:, conditions:[])
      @db = db
      @table = table
      @conditions = conditions
    end

    def where(filters)
      new_conditions = filters.map do |field, value|
        QueryCondition.new field, value
      end

      Dataset.new db, table: table, conditions: conditions + new_conditions
    end

    def each(&block)
      all.each(&block)
    end

    def all
      statement = Statements::Select.new table: table, conditions: conditions
      result = db.execute statement.cql, statement.options
      result.to_a
    end

    def insert(attributes)
      statement = Statements::Insert.new table: table, attributes: attributes
      db.execute statement.cql, statement.options
    end

    def update(attributes)
      statement = Statements::Update.new table: table, attributes: attributes, conditions: conditions
      db.execute statement.cql, statement.options
    end

    def delete
      statement = Statements::Delete.new table: table, conditions: conditions
      db.execute statement.cql, statement.options
    end

    def inspect
      statement = Statements::Select.new table: table, conditions: conditions
      "#<#{self.class.name}: #{statement.to_s}>"
    end

    private

    attr_reader :db, :table, :conditions

  end
end