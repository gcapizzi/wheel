require 'sequel/core'

module Scrooge
  class Mapping
    class << self
      attr_accessor :klass, :fields
    end

    def from_record(record)
      fields_with_id.inject(klass.new) do |object, field|
        object.send("#{field}=", record[field]) if record[field]
        object
      end
    end

    def to_record(object)
      fields.inject({}) do |record, field|
        record[field] = object.send(field) if object.respond_to? field
        record
      end
    end

    private

    def fields; self.class.fields; end
    def fields_with_id; fields + [:id]; end
    def klass; self.class.klass; end
  end
end
