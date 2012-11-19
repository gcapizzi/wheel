require 'sequel/core'

module Scrooge
  class Mapper
    def initialize(dataset)
      @dataset = dataset
    end

    def save(object)
      if saved? object
        update(object)
      else
        insert(object)
      end
    end

    def delete(object)
      @dataset.where(id: object.id).delete if saved? object
    end

    def find(id)
      record = @dataset.where(id: id)
      object = from_record(record.first) if !record.empty?
      return object
    end

    private

    def insert(object)
      id = @dataset.insert(attrs(object))
      object.id = id
    end

    def update(object)
      @dataset.where(id: object.id).update(attrs(object))
    end

    def saved?(object)
      !object.id.nil?
    end
  end
end
