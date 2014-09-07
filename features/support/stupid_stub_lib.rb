# Apparently I can't use RSpec mocks in my cukes.
# Didn't really look too hard to see how much work would be required to change that
# b/c it's not too hard to get something stupid that works good enough

class StupidStubLib
  def stub(context, target, method_name, response)
    real_method = target.method(method_name)
    stubs[context] << [target, method_name, real_method]
    target.define_singleton_method(method_name) { |*| response }
  end

  def unstub(context)
    old_stubs = stubs[context]
    stubs.delete context
    old_stubs.each do |target, method_name, real_method|
      target.define_singleton_method(method_name, &real_method)
    end
  end

  private

  def stubs
    @stubs ||= Hash.new { |h, k| h[k] = [] }
  end
end
