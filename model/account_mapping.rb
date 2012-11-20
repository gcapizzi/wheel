require 'sequel/core'
require_relative 'mapper'
require_relative 'account'

module Scrooge
  class AccountMapping
    def to_record(account)
      { name: account.name }
    end

    def from_record(record)
      account = Account.new()
      account.id = record[:id]
      account.name = record[:name]

      return account
    end
  end
end
