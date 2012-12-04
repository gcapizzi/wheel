require 'sequel/core'

module Scrooge

  @mappings = {}

  class << self
    attr_reader :mappings

    def clear_mappings!
      @mappings = {}
    end

    def register_mapping(klass, mapping)
      @mappings[klass] = mapping
    end
  end

  class Mapping
    attr_reader :klass, :table

    def initialize(klass, table = nil)
      @klass = klass
      @table = table || table_name_from_class_name(klass.name)
    end

    def fields(*fields)
      @fields ||= []
      @fields |= fields
    end

    def to_record(object)
      @fields.inject({}) do |record, field|
        record[field] = object.send(field) if object.respond_to? field
        record
      end
    end

    def from_record(record)
      fields_with_id.inject(@klass.new) do |object, field|
        object.send("#{field}=", record[field]) if record[field]
        object
      end
    end

    private

    def fields_with_id; @fields + [:id]; end

    def table_name_from_class_name(class_name)
      class_name.split('::').last.downcase.to_sym
    end
  end

end
