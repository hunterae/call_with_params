class CallWithParams
  def self.call(*args)
    return nil if args.empty?
    v = args.shift
    v.is_a?(Proc) ? v.call(*(args[0, v.arity])) : v
  end
end