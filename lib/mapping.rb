require 'sequel/core'

module Wheel

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
      record = {}
      @fields.each do |field|
        record[field] = object.send(field) if object.respond_to? field
      end
      record
    end

    def from_record(record)
      object = @klass.new
      fields_with_id.each do |field|
        object.send("#{field}=", record[field]) if record[field]
      end
      object
    end

    private

    def fields_with_id; @fields + [:id]; end

    def table_name_from_class_name(class_name)
      class_name.split('::').last.downcase.to_sym
    end
  end

end
