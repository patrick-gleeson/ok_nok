require 'spec_helper'

describe OkNok do
  
  context 'when ok' do
    let(:happy_value) { 'Hooray this worked' }
    subject { OkNok.new(OkNok::OK, happy_value) }

    describe '#ok?' do    
      it 'is ok' do
        expect(subject.ok?).to eq true
      end      
    end
    
    describe '#value' do
      it 'is the value passed in'
        expect(subject.value).to eq happy_value
      end
    end
  end
end