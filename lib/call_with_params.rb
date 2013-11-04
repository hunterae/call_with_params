module CallWithParams
  def call_with_params(*args)
    return nil if args.empty?
    v = args.shift
    v.is_a?(Proc) ? v.call(*(args[0, v.arity])) : v
  end

  def call_each_hash_value_with_params(*args)
    return {} if args.empty?

    options = args.shift || {}
    if options.is_a?(Proc)
      call_with_params(options, *args)
    else
      options.inject(HashWithIndifferentAccess.new) { |hash, (k, v)| hash[k] = call_with_params(v, *args); hash}
    end
  end
end