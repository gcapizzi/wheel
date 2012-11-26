require 'sequel/core'
require_relative '../transaction'
require_relative '../mapping'

module Scrooge

  class TransactionMapping < Mapping
    maps Transaction
    fields :description, :amount
  end

end
