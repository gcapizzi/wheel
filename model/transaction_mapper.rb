require 'sequel/core'
require_relative 'transaction'

module Scrooge
  class TransactionMapper
    def initialize(dataset)
      @dataset = dataset
    end

    def save(transaction)
      if saved? transaction
        update(transaction)
      else
        insert(transaction)
      end
    end

    def delete(transaction)
      @dataset.where(id: transaction.id).delete if saved? transaction
    end

    def find(id)
      record = @dataset.where(id: id)
      transaction = from_record(record.first) if !record.empty?
      return transaction
    end

    private

    def attrs(transaction)
      { description: transaction.description, amount: transaction.amount }
    end

    def from_record(attrs)
      transaction = Transaction.new()
      transaction.id = attrs[:id]
      transaction.description = attrs[:description]
      transaction.amount = attrs[:amount]

      return transaction
    end

    def insert(transaction)
      id = @dataset.insert(attrs(transaction))
      transaction.id = id
    end

    def update(transaction)
      @dataset.where(id: transaction.id).update(attrs(transaction))
    end

    def saved?(transaction)
      !transaction.id.nil?
    end
  end
end
