module CassandraDB
  class QueryCondition

    attr_reader :field, :value, :operator

    def initialize(field, value)
      @field = field
      @value = value
      @operator = value.is_a?(Array) ? 'IN' : '='
    end

    def to_cql
      "#{field} #{operator} :#{field}"
    end

    def to_argument
      {field => value}
    end

  end
end
