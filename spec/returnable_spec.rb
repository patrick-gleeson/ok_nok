require 'spec_helper'

describe OkNok::Returnable do
  let(:happy_value) { 'Hooray this worked' }
  let(:sad_value) { 'Oh no this failed' }
  let(:ok_object) {OkNok::Returnable.new(OkNok::OK, happy_value)}
  let(:nok_object){OkNok::Returnable.new(OkNok::NOK, sad_value) }
  
  context 'when initialized as ok' do
    describe '#value' do
      it 'contains the value passed in' do
        expect(ok_object.value).to eq happy_value
      end
    end
    
    describe '#status' do
      it 'is ok' do
        expect(ok_object.status).to eq OkNok::OK
      end
    end

    describe '#ok?' do    
      it 'is true' do
        expect(ok_object.ok?).to eq true
      end      
    end

    describe '#nok?' do    
      it 'is false' do
        expect(ok_object.nok?).to eq false
      end      
    end
    
    describe "#value_or_if_nok" do
      it "doesn't execute a provided block" do
        expect{|block| ok_object.value_or_if_nok(&block)}.not_to yield_control
      end
      
      it "returns its value" do
        expect(ok_object.value_or_if_nok {|nok_value| nil}).to eq ok_object.value
      end
    end
    
    describe "#value_or_if_ok" do
      it "executes a provided block" do
        expect{|block| ok_object.value_or_if_ok(&block)}.to yield_control
      end
      
      it "returns nil if no block provided" do
        expect(ok_object.value_or_if_ok).to be_nil
      end
      
      it "returns the result of the block if a block is provided" do
        expect(ok_object.value_or_if_ok {|nok_value| "Some result"}).to eq "Some result"
      end
      
      it "provides its value as an argument to the block" do
        ok_object.value_or_if_ok do |ok_value|
          expect(ok_value).to eq ok_object.value
        end
      end
    end
    
    describe "#ok" do
      it "executes a provided block" do
        expect{|block| ok_object.ok(&block)}.to yield_control
      end
      
      it "returns itself" do
        expect(ok_object.ok {|ok_value| nil}).to eq ok_object
      end
      
      it "provides its value as an argument to the block" do
        ok_object.ok do |ok_value|
          expect(ok_value).to eq ok_object.value
        end
      end
    end
    
    describe "#nok" do
      it "doesn't execute a provided block" do
        expect{|block| ok_object.nok(&block)}.not_to yield_control
      end
      
      it "returns itself" do
        expect(ok_object.nok {|nok_value| nil}).to eq ok_object
      end
    end
  end
  
  context 'when initialized as nok' do
    describe '#value' do
      it 'contains the value passed in' do
        expect(nok_object.value).to eq sad_value
      end
    end
    
    describe '#status' do
      it 'is nok' do
        expect(nok_object.status).to eq OkNok::NOK
      end
    end

    describe '#ok?' do    
      it 'is false' do
        expect(nok_object.ok?).to eq false
      end      
    end

    describe '#nok?' do    
      it 'is true' do
        expect(nok_object.nok?).to eq true
      end      
    end
    
    describe "#value_or_if_nok" do
      it "executes a provided block" do
        expect{|block| nok_object.value_or_if_nok(&block)}.to yield_control
      end
      
      it "returns nil if no block provided" do
        expect(nok_object.value_or_if_nok).to be_nil
      end
      
      it "returns the result of the block if a block is provided" do
        expect(nok_object.value_or_if_nok {|nok_value| "Some result"}).to eq "Some result"
      end
      
      it "provides the nok value as an argument to the block" do
        nok_object.value_or_if_nok do |nok_value|
          expect(nok_value).to eq nok_object.value
        end
      end
    end
    
    describe "#value_or_if_ok" do
      it "doesn't execute a provided block" do
        expect{|block| nok_object.value_or_if_ok(&block)}.not_to yield_control
      end
      
      it "returns its value" do
        expect(nok_object.value_or_if_ok {|ok_value| nil}).to eq nok_object.value
      end
    end
    
    describe "#ok" do
      it "doesn't execute a provided block" do
        expect{|block| nok_object.ok(&block)}.not_to yield_control
      end
      
      it "returns itself" do
        expect(nok_object.ok {|ok_value| nil}).to eq nok_object
      end
    end
    
    describe "#nok" do
      it "executes a provided block" do
        expect{|block| nok_object.nok(&block)}.to yield_control
      end
      
      it "returns itself" do
        expect(nok_object.nok {|nok_value| nil}).to eq nok_object
      end
      
      it "provides its value as an argument to the block" do
        nok_object.nok do |nok_value|
          expect(nok_value).to eq nok_object.value
        end
      end
    end
  end
  
  context 'when initialized with non ok/nok status' do
    it 'raises an ArgumentError' do
      expect{OkNok::Returnable.new("not a status", "some value")}.to raise_error(ArgumentError)
    end
  end  
end
