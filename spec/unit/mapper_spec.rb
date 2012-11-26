require 'spec_helper'
require 'ostruct'
require_relative '../../lib/mapper'

module Scrooge

  describe Mapper do
    let(:dataset) { double("Dataset") }
    let(:mapping) { double("Mapping") }
    let(:mapper) { Mapper.new(dataset, mapping) }

    let(:attributes) { { a: 1, b: 2, c: 3 } }
    let(:object) { OpenStruct.new(attributes) }
    let(:saved_attributes) { attributes.merge(id: 1) }
    let(:saved_object) { OpenStruct.new(saved_attributes) }

    describe '#save' do
      context 'when the object has never been saved' do
        it 'calls insert on the dataset and sets the object id' do
          mapping.should_receive(:to_record).with(object)
            .and_return(attributes)
          dataset.should_receive(:insert).with(attributes).and_return(1)

          mapper.save(object)

          object.id.should == 1
        end
      end

      context 'when the object has already been saved' do
        it 'calls update on the dataset' do
          mapping.should_receive(:to_record).with(saved_object)
            .and_return(attributes)
          object_dataset = double("Object dataset")
          dataset.should_receive(:where).with(id: saved_object.id)
            .and_return(object_dataset)
          object_dataset.should_receive(:update).with(attributes)

          mapper.save(saved_object)
        end
      end
    end

    describe '#delete' do
      context 'when the object has already been saved' do
        it 'calls delete on the dataset' do
          object_dataset = double("Object dataset")
          dataset.should_receive(:where).with(id: saved_object.id)
            .and_return(object_dataset)
          object_dataset.should_receive(:delete)

          mapper.delete(saved_object)
        end
      end

      context 'when the object has never been saved' do
         it 'does nothing' do
           dataset.should_not_receive(:where)

           mapper.delete(object)
         end
      end
    end

    describe '#find' do
      it 'calls where on the dataset' do
        object_dataset = double("Object dataset")
        dataset.should_receive(:where).with(id: 1).and_return(object_dataset)
        object_dataset.stub(:empty?).and_return(false)
        object_dataset.should_receive(:first).and_return(saved_attributes)
        mapping.should_receive(:from_record)
          .with(saved_attributes).and_return(saved_object)

        found = mapper.find(1)

        found.should == saved_object
      end

      it 'returns nil if no object is found' do
        empty_dataset = double("Empty dataset")
        dataset.should_receive(:where).with(id: 99).and_return(empty_dataset)
        empty_dataset.should_receive(:empty?).and_return(true)

        found = mapper.find(99)

        found.should be_nil
      end
    end
  end

end
