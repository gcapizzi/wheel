require 'sequel/core'

module Scrooge

  class Mapper
    def initialize(db, mapping)
      @db = db
      @mapping = mapping
    end

    def dataset
      @db[@mapping.table]
    end

    def save(object)
      if saved? object
        update(object)
      else
        insert(object)
      end
    end

    def delete(object)
      dataset.where(id: object.id).delete if saved? object
    end

    def find(id)
      record = dataset.where(id: id)
      object = @mapping.from_record(record.first) if !record.empty?
      return object
    end

    private

    def insert(object)
      record = @mapping.to_record(object)
      id = dataset.insert(record)
      object.id = id
    end

    def update(object)
      record = @mapping.to_record(object)
      dataset.where(id: object.id).update(record)
    end

    def saved?(object)
      !object.id.nil?
    end
  end

end
