require 'sequel/core'
require_relative 'mapper'
require_relative 'transaction'

module Scrooge
  class TransactionMapper < Mapper
    protected

    def attrs(transaction)
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
