require 'rspec'
require_relative '../../lib/mapping'

module Scrooge
  describe Mapping do
    let (:klass) { double("Fake class") }
    let (:mapping) do
      class FakeMapping < Mapping; end
      FakeMapping.klass = klass
      FakeMapping.fields = [:one, :two, :three]
      FakeMapping
    end

    describe '#from_record' do
      it 'creates an object from a record hash' do
        instance = double("Fake class instance")
        klass.should_receive(:new).and_return(instance)
        instance.should_receive(:one=).with(1)
        instance.should_receive(:two=).with(2)
        instance.should_receive(:three=).with(3)
        instance.should_not_receive(:four=)

        object = mapping.from_record(one: 1, two: 2, three: 3, four: 4)

        object.should == instance
      end
    end

    describe '#to_record' do
      it 'converts an object to a record hash' do
        instance = double("Fake class instance")
        instance.should_receive(:respond_to?).with(:one).and_return(true)
        instance.should_receive(:one).and_return(1)
        instance.should_receive(:respond_to?).with(:two).and_return(true)
        instance.should_receive(:two).and_return(2)
        instance.should_receive(:respond_to?).with(:three).and_return(false)
        instance.should_not_receive(:three)

        record = mapping.to_record(instance)

        record.should == { one: 1, two: 2 }
      end
    end
  end
end
