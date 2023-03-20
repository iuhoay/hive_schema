module HiveSchema
  class Column
    attr_reader :name, :type, :comment

    def initialize(name, type, comment)
      @name = name
      @type = type
      @comment = comment
    end

    def to_s
      "`#{@name}` #{@type} COMMENT '#{@comment}'"
    end
  end
end
