require 'sequel/core'
require_relative '../transaction'
require_relative '../mapping'

module Scrooge
  class TransactionMapping < Mapping
    @klass = Transaction
    @fields = [:description, :amount]
  end
end
