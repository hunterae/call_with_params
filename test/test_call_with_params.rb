require 'helper'

class TestCallWithParams < Test::Unit::TestCase
  context "when no arguments are passed in" do
    should "return nil" do
      assert_equal nil, CallWithParams.call
    end
  end

  context "when the first argument is not a Proc" do
    should "return the first parameter regardless of how many additional params are passed" do
      assert_equal "first param", CallWithParams.call("first param")
      assert_equal "first param", CallWithParams.call("first param", 2, 3, "fourth param")
    end
  end

  context "with the first argument as a Proc" do
    should "call the Proc" do
      assert_equal "result of proc", CallWithParams.call(Proc.new { "result of proc" })
    end

    should "pass arguments to the Proc" do
      assert_equal "result of proc 1 2", CallWithParams.call(Proc.new {|param1, param2| "result of proc #{param1} #{param2}" }, 1, 2)
    end

    should "pass only the number of arguments that the Proc takes" do
      assert_equal "result of proc 1", CallWithParams.call(Proc.new {|param1| "result of proc #{param1}" }, 1, 2, 3, 4)
      assert_equal "result of proc", CallWithParams.call(Proc.new {"result of proc" }, 1, 2, 3, 4)
    end
  end
end
