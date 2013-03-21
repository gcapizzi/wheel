require 'spec_helper'
require 'rspec'
require_relative '../../lib/mapping'

module Wheel

  describe Mapping do
    let (:klass) { double("Fake class") }
    let (:instance) { double("Fake class instance") }
    let (:table) { :fake }
    let (:mapping) do
      mapping = Mapping.new(klass, table)
      mapping.fields :one, :two, :three
      mapping
    end

    describe '#initialize' do
      it 'sets mapped class and table' do
        mapping = Mapping.new(klass, table)
        expect(mapping.klass).to eq(klass)
        expect(mapping.table).to eq(table)
      end
    end

    describe '#table' do
      it 'returns the table name as a symbol' do
        expect(mapping.table).to eq(table)
      end
    end

    describe '#from_record' do
      it 'creates an object from a record hash' do
        klass.should_receive(:new).and_return(instance)
        instance.should_receive(:one=).with(1)
        instance.should_receive(:two=).with(2)
        instance.should_receive(:three=).with(3)
        instance.should_not_receive(:four=)

        object = mapping.from_record(one: 1, two: 2, three: 3, four: 4)

        expect(object).to eq(instance)
      end
    end

    describe '#to_record' do
      it 'converts an object to a record hash' do
        instance.should_receive(:respond_to?).with(:one).and_return(true)
        instance.should_receive(:one).and_return(1)
        instance.should_receive(:respond_to?).with(:two).and_return(true)
        instance.should_receive(:two).and_return(2)
        instance.should_receive(:respond_to?).with(:three).and_return(false)
        instance.should_not_receive(:three)

        record = mapping.to_record(instance)

        expect(record).to eq({ one: 1, two: 2 })
      end
    end
  end

end
