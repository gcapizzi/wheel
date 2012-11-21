require 'sequel/core'
require_relative '../transaction'

module Scrooge
  class TransactionMapping
    def to_record(transaction)
      { description: transaction.description, amount: transaction.amount }
    end

    def from_record(record)
      transaction = Transaction.new()
      transaction.id = record[:id]
      transaction.description = record[:description]
      transaction.amount = record[:amount]

      return transaction
    end
  end
end
