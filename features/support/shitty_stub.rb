# Apparently I can't use RSpec mocks in my cukes.
# Didn't really look too hard to see how much work would be required to change that
# b/c it's not too hard to get something stupid that works good enough

class ShittyStub
  Stub = Struct.new :target, :method_name, :real_method, :stubbed_method do
    def unstub
      target.define_singleton_method(method_name, &real_method)
    end
  end

  def stub(target, method_name, response)
    real_method = target.method(method_name)
    target.define_singleton_method(method_name) { |*| response }
    stubbed_method = target.method(method_name)
    stubs << Stub.new(target, method_name, real_method, stubbed_method)
    nil
  end

  def unstub
    return nil if stubs.empty?
    stubs.pop.unstub
    unstub
  end

  private

  def stubs
    @stubs ||= []
  end
end
