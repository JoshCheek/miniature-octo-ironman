require File.expand_path('../../features/support/shitty_stub', __FILE__)

# Omg, testing test code!

RSpec.describe ShittyStub do
  class SomeClass
    def m
      :original
    end
  end

  let(:obj)     { SomeClass.new }
  let(:stubber) { ShittyStub.new }

  describe 'stubbing' do
    it 'causes the target to return the response when the method is invoked' do
      expect(obj.m).to eq :original
      stubber.stub obj, :m, :new
      expect(obj.m).to eq :new
      expect(obj.m).to eq :new
    end

    it 'only stubs the method on the target, not every instance or w/e' do
      obj1 = SomeClass.new
      obj2 = SomeClass.new
      stubber.stub obj1, :m, :new
      expect(obj1.m).to eq :new
      expect(obj2.m).to eq :original
    end

    it 'returns nil (for encapsulation)' do
      expect(stubber.stub obj, :m, :new).to eq nil
    end
  end


  describe 'unstubbing' do
    it 'can unstub the methods' do
      stubber.stub obj, :m, :new
      expect(obj.m).to eq :new
      stubber.unstub
      expect(obj.m).to eq :original
    end

    it 'unstubs to the original value, even if it was stubbed multiple times' do
      stubber.stub obj, :m, :override1
      stubber.stub obj, :m, :override2
      stubber.unstub
      expect(obj.m).to eq :original
    end

    it 'can unstub multiple times and be fine' do
      expect { stubber.unstub }.to_not raise_error
      expect { stubber.unstub }.to_not raise_error
    end

    it 'returns nil' do
      expect(stubber.unstub).to eq nil
      stubber.stub obj, :m, :new
      expect(stubber.unstub).to eq nil
    end
  end
end
