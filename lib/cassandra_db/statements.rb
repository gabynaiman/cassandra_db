module CassandraDB
  module Statements
    class Base

      def options
        {arguments: arguments}
      end

      def to_s
        "#{cql} #{options}"
      end

      private

      def where_cql
        conditions.any? ? "WHERE #{conditions.map(&:to_cql).join(' AND ')}" : ''
      end

      def conditions_agruments
        conditions.each_with_object({}) do |condition, agruments|
          agruments.merge! condition.to_argument
        end
      end

    end

    class Select < Base

      attr_reader :table, :conditions

      def initialize(table:, conditions:[])
        @table = table
        @conditions = conditions
      end

      def cql
        @cql ||= "SELECT * FROM #{table} #{where_cql}".strip
      end

      def arguments
        @arguments ||= conditions_agruments
      end

    end

    class Insert < Base

      attr_reader :table, :attributes

      def initialize(table:, attributes:)
        @table = table
        @attributes = attributes
      end

      def cql
        @cql ||= "INSERT INTO #{table} (#{field_names}) VALUES (#{field_references})"
      end

      def arguments
        attributes
      end

      private

      def field_names
        attributes.keys.join(', ')
      end

      def field_references
        attributes.keys.map { |f| ":#{f}" }.join(', ')
      end

    end

    class Update < Base

      attr_reader :table, :attributes, :conditions

      def initialize(table:, attributes:, conditions:)
        @table = table
        @attributes = attributes
        @conditions = conditions
      end

      def cql
        @cql ||= "UPDATE #{table} SET #{filed_mappings} #{where_cql}"
      end

      def arguments
        @arguments ||= attributes.merge(conditions_agruments)
      end

      private

      def filed_mappings
        attributes.keys.map { |f| "#{f} = :#{f}" }.join(', ')
      end

    end

    class Delete < Base

      attr_reader :table, :conditions

      def initialize(table:, conditions:)
        @table = table
        @conditions = conditions
      end

      def cql
        @cql ||= "DELETE FROM #{table} #{where_cql}"
      end

      def arguments
        @arguments ||= conditions_agruments
      end

    end

  end
end