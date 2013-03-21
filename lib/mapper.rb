require 'sequel/core'

module Wheel

  class Mapper
    def initialize(db, mapping)
      @db = db
      @mapping = mapping
    end

    def dataset
      @db[@mapping.table]
    end

    def save(object)
      if saved?(object)
        update(object)
      else
        insert(object)
      end
    end

    def delete(object)
      dataset.where(id: object.id).delete if saved?(object)
    end

    def find(id)
      record = dataset.where(id: id).first
      @mapping.from_record(record) if !record.nil?
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
