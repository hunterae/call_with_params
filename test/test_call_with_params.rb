require 'helper'

class TestCallWithParams < Test::Unit::TestCase
  def setup
    @klass = Class.new
    @klass.send(:include, CallWithParams)
    @call_with_params = @klass.new
  end

  context "call_with_params" do
    context "when no arguments are passed in" do
      should "return nil" do
        assert_equal nil, @call_with_params.call_with_params
      end
    end

    context "when the first arugment is nil" do
      should "return nil" do
        assert_equal nil, @call_with_params.call_with_params(nil, 1, 2)
      end
    end

    context "when the first argument is not a Proc" do
      should "return the first parameter regardless of how many additional params are passed" do
        assert_equal "first param", @call_with_params.call_with_params("first param")
        assert_equal "first param", @call_with_params.call_with_params("first param", 2, 3, "fourth param")
      end
    end

    context "with the first argument as a Proc" do
      should "call the Proc" do
        assert_equal "result of proc", @call_with_params.call_with_params(Proc.new { "result of proc" })
      end

      should "pass arguments to the Proc" do
        assert_equal "result of proc 1 2", @call_with_params.call_with_params(Proc.new {|param1, param2| "result of proc #{param1} #{param2}" }, 1, 2)
      end

      should "pass only the number of arguments that the Proc takes" do
        assert_equal "result of proc 1", @call_with_params.call_with_params(Proc.new {|param1| "result of proc #{param1}" }, 1, 2, 3, 4)
        assert_equal "result of proc", @call_with_params.call_with_params(Proc.new {"result of proc" }, 1, 2, 3, 4)
      end
    end
  end

  context "call_each_hash_value_with_params" do
    context "when no arguments are passed in" do
      should "return an empty hash" do
        assert_equal({}, @call_with_params.call_each_hash_value_with_params)
      end
    end

    context "when the first argument is nil" do
      should "return an empty hash" do
        assert_equal({}, @call_with_params.call_each_hash_value_with_params(nil))
      end
    end

    context "when the first argument is a Proc" do
      should "delegate to the call_with_params method" do
        proc = Proc.new {}
        @call_with_params.expects(:call_with_params).with(proc, 1, 2, 3).returns("delegated result")
        assert_equal "delegated result", @call_with_params.call_each_hash_value_with_params(proc, 1, 2, 3)
      end
    end

    context "when the first argument is a hash" do
      should "call each value in the hash if it is a Proc" do
        assert_equal({:id => "my-id", :class => "my-class"},
          @call_with_params.call_each_hash_value_with_params(:id => Proc.new{ "my-id" }, :class => Proc.new { "my-class" }))
      end

      should "be able to take a mixture of Procs and non-Procs as hash values" do
        assert_equal({:id => "my-id", :class => "my-class"},
          @call_with_params.call_each_hash_value_with_params(:id => "my-id", :class => Proc.new { "my-class" }))
      end

      should "be able to pass any additional arguments into each proc" do
        assert_equal({:id => "object-45", :class => "row-13"},
          @call_with_params.call_each_hash_value_with_params(
            {:id => Proc.new{|id| "object-#{id}" }, :class => Proc.new { |id, row_number| "row-#{row_number}" }}, 45, 13))
      end
    end
  end
end