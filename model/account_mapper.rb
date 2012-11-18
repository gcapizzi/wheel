require 'sequel/core'
require_relative 'account'

module Scrooge
  class AccountMapper
    def initialize(dataset)
      @dataset = dataset
    end

    def save(account)
      if saved? account
        update(account)
      else
        insert(account)
      end
    end

    def delete(account)
      @dataset.where(id: account.id).delete if saved? account
    end

    def find(id)
      record = @dataset.where(id: id)
      account = from_record(record.first) if !record.empty?
      return account
    end

    private

    def attrs(account)
      { name: account.name }
    end

    def from_record(attrs)
      account = Account.new()
      account.id = attrs[:id]
      account.name = attrs[:name]

      return account
    end

    def insert(account)
      id = @dataset.insert(attrs(account))
      account.id = id
    end

    def update(account)
      @dataset.where(id: account.id).update(attrs(account))
    end

    def saved?(account)
      !account.id.nil?
    end
  end
end
