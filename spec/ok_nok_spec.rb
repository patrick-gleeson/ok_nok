require 'spec_helper'

include OkNok

describe OkNok do
  let(:value_passed_in) { "SomeValue" }
  let(:provided_nok_value) { "Return me if nok" }
  let(:ok_block_return_value) { "other value" }
  
  describe '#ok' do
    let(:returned) { ok value_passed_in }
    
    it 'returns an OkNok' do
      expect(returned).to be_an(OkNok)
    end
    
    it 'sets status to "ok"' do
      expect(returned.status).to be OkNok::OK
    end
    
    it 'keeps the value passed in' do
      expect(returned.value).to be value_passed_in
    end
  end
  
  describe '#nok' do
    let(:returned) { nok value_passed_in }
    it 'returns an OkNok' do
      expect(returned).to be_an(OkNok)
    end
    
    it 'sets status to "nok"' do
      expect(returned.status).to be OkNok::NOK
    end
    
    it 'keeps the value passed in' do
      expect(returned.value).to be value_passed_in
    end
  end 
  
  describe ".nok_if" do
    let(:comparison_value) {"If you get me, return a nok"}
    
    it 'executes a provided block' do
      expect{|block| OkNok.nok_if(comparison_value, provided_nok_value, &block)}.to yield_control
    end
    
    it 'raises an ArgumentError if there\'s no block' do
      expect{OkNok.nok_if(comparison_value, provided_nok_value)}.to raise_error(ArgumentError)
    end
    
    context "when the block return value equals the comparison value" do
      let(:nok_if_return_value) do 
        OkNok.nok_if comparison_value, provided_nok_value do 
          comparison_value
        end
      end
      
      it "returns an oknok" do
        expect(nok_if_return_value).to be_an(OkNok)
      end
      
      it "returns a nok" do
        expect(nok_if_return_value.nok?).to be true
      end
      
      it "assigns the provided value to the nok" do
        expect(nok_if_return_value.value).to eq provided_nok_value
      end
    end
    
    context "when the block return value doesn't equal the comparison value" do      
      let(:nok_if_return_value) do
        OkNok.nok_if comparison_value, provided_nok_value do 
          ok_block_return_value 
         end
      end
      
      it "returns an oknok" do
        expect(nok_if_return_value).to be_an(OkNok)
      end
      
      it "returns an ok" do
        expect(nok_if_return_value.ok?).to be true
      end
      
      it "assigns the block return value to the ok" do
        expect(nok_if_return_value.value).to eq ok_block_return_value
      end
    end    
  end
  
  describe ".nok_if_exception" do
    it 'executes a provided block' do
      expect{|block| OkNok.nok_if_exception(provided_nok_value, &block)}.to yield_control
    end
    
    it 'raises an ArgumentError if there\'s no block' do
      expect{OkNok.nok_if_exception}.to raise_error(ArgumentError)
    end
    
    context "when the block doesn't raise an exception" do
      let(:nok_if_exception) do
        OkNok.nok_if_exception provided_nok_value do 
          ok_block_return_value 
         end
      end
      
      it "returns an oknok" do
        expect(nok_if_exception).to be_an(OkNok)
      end
      
      it "returns an ok" do
        expect(nok_if_exception.ok?).to be true
      end
      
      it "assigns the block return value to the ok" do
        expect(nok_if_exception.value).to eq ok_block_return_value
      end
    end
    
    context "when the block raises an exception" do
      let(:nok_if_exception) do
        OkNok.nok_if_exception provided_nok_value do 
           raise "This block has issues!"
         end
      end
      it "returns an oknok" do
        expect(nok_if_exception).to be_an(OkNok)
      end
      
      it "returns a nok" do
        expect(nok_if_exception.nok?).to be true
      end
      
      it "assigns the provided return value to the nok" do
        expect(nok_if_exception.value).to eq provided_nok_value
      end
    end
  end    
end

