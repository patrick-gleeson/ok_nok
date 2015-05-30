require 'spec_helper'

include OkNok

describe OkNok do
  let(:value_passed_in) { "SomeValue" }
  let(:provided_nok_value) { "Return me if nok" }
  let(:ok_block_return_value) { "other value" }
  
  describe '#ok' do
    subject { ok value_passed_in }
    
    specify do
      expect(subject).to be_an(OkNok)
    end
    
    it 'sets status to "ok"' do
      expect(subject.status).to be OkNok::OK
    end
    
    it 'keeps the value passed in' do
      expect(subject.value).to be value_passed_in
    end
  end
  
  describe '#nok' do
    subject { nok value_passed_in }
    
    specify do
      expect(subject).to be_an(OkNok)
    end
    
    it 'sets status to "nok"' do
      expect(subject.status).to be OkNok::NOK
    end
    
    it 'keeps the value passed in' do
      expect(subject.value).to be value_passed_in
    end
  end 
  
  describe ".nok_if" do
    let(:comparison_value) {"If you get me, return a nok"}
    
    specify do
      expect{|block| OkNok.nok_if(comparison_value, provided_nok_value, &block)}.to yield_control
    end
    
    context "when no block is provided" do
      specify do
        expect{OkNok.nok_if(comparison_value, provided_nok_value)}.to raise_error(ArgumentError)
      end
    end
    
    context "when the block return value equals the comparison value" do
      subject do 
        OkNok.nok_if comparison_value, provided_nok_value do 
          comparison_value
        end
      end
      
      specify do
        expect(subject).to be_an(OkNok)
      end
      
      specify do
        expect(subject).to be_nok
      end
      
      it "assigns the provided value to the nok" do
        expect(subject.value).to eq provided_nok_value
      end
    end
    
    context "when the block return value doesn't equal the comparison value" do      
      subject do
        OkNok.nok_if comparison_value, provided_nok_value do 
          ok_block_return_value 
         end
      end
      
      specify do
        expect(subject).to be_an(OkNok)
      end
      
      specify do
        expect(subject).to be_ok
      end
      
      it "assigns the block return value to the ok" do
        expect(subject.value).to eq ok_block_return_value
      end
    end    
  end
  
  describe ".nok_if_exception" do
    specify do
      expect{|block| OkNok.nok_if_exception(provided_nok_value, &block)}.to yield_control
    end
    
    context "when no block is provided" do
      specify do
        expect{OkNok.nok_if_exception}.to raise_error(ArgumentError)
      end      
    end
    
    context "when the block doesn't raise an exception" do
      subject do
        OkNok.nok_if_exception provided_nok_value do 
          ok_block_return_value 
         end
      end
      
      specify do
        expect(subject).to be_an(OkNok)
      end
      
      specify do
        expect(subject).to be_ok
      end
      
      it "assigns the block return value to the ok" do
        expect(subject.value).to eq ok_block_return_value
      end
    end
    
    context "when the block raises an exception" do
      subject do
        OkNok.nok_if_exception provided_nok_value do 
           raise "This block has issues!"
         end
      end
      specify do
        expect(subject).to be_an(OkNok)
      end
      
      specify do
        expect(subject).to be_nok
      end
      
      it "assigns the provided return value to the nok" do
        expect(subject.value).to eq provided_nok_value
      end
    end
  end    
end

