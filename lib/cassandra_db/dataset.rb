module CassandraDB
  class Dataset

    include Enumerable

    def initialize(db, from:, where:[])
      @db = db
      @table = from
      @conditions = where
    end

    def where(filters)
      new_conditions = filters.map do |field, value|
        {
          field: field,
          operator: value.is_a?(Array) ? 'IN' : '=',
          value: value
        }
      end

      Dataset.new db, from: table, where: conditions + new_conditions
    end

    def each(&block)
      all.each(&block)
    end

    def all
      db.execute(*cql).to_a
    end

    def cql
      select = 'SELECT *'
      from = "FROM #{table}"
      where = conditions.any? ? "WHERE #{conditions.map { |c| "#{c[:field]} #{c[:operator]} :#{c[:field]}" }.join(' AND ')}" : ''
      arguments = conditions.each_with_object({}) { |c,h| h[c[:field]] = c[:value] }

      [
        "#{select} #{from} #{where}".strip,
        {arguments: arguments}
      ]
    end

    def inspect
      "#<#{self.class.name}: #{cql.join(', ')}>"
    end

    private

    attr_reader :db, :table, :conditions
  end
end