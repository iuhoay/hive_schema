module HiveSchema
  class Table
    attr_reader :name, :columns, :partition_columns
    attr_accessor :stored_as, :location

    def initialize(schema, name)
      @schema = schema
      @name = name
      @columns = []
      @partition_columns = []
      @stored_as = "TEXTFILE"
    end

    def add_column(name, type, comment)
      @columns << Column.new(name, type, comment)
    end

    # Add partition column
    def add_partition_column(name, type, comment)
      @partition_columns << Column.new(name, type, comment)
    end

    def to_s
      <<~SQL
        CREATE TABLE IF NOT EXISTS `#{@schema}.#{@name}` (
          #{columns.map(&:to_s).join(",\n")}
        )
        #{attributes};
      SQL
    end

    private

    def attributes
      [
        "COMMENT '#{@name}'",
        @partition_columns.any? ? "PARTITIONED BY (#{partition_columns.map(&:to_s).join(", ")})" : nil,
        "ROW FORMAT DELIMITED FIELDS",
        "TERMINATED BY '\\t'",
        "STORED AS #{@stored_as}",
        @location ? "LOCATION '#{@location}'" : nil
      ].compact.join("\n")
    end
  end
end
