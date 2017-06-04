require 'test_helper'

class Minitest::CustomizeResultTest < Minitest::Test
  attr_accessor :reporter, :output

  def setup
    @output = StringIO.new("")
    io = Minitest::CustomizeResult::Reporter.new(@output)

    self.reporter = Minitest::CompositeReporter.new
    reporter << Minitest::ProgressReporter.new(io)
  end

  def test_customize_result
    test_case = Class.new(Minitest::Test) do
      Minitest::CustomizeResult.use!({'.' => '🍎', 'E' =>'💀', 'F' => '🔥', 'S' => '🐧'})

      def test_success
        assert true
      end

      def test_fail
        assert false
      end

      def test_error
        raise 'error'
      end

      def test_skip
        skip 'skipped test'
      end
    end

    reporter.start
    reporter.record(test_case.new(:test_success).run)
    reporter.record(test_case.new(:test_fail).run)
    reporter.record(test_case.new(:test_error).run)
    reporter.record(test_case.new(:test_skip).run)
    reporter.report

    assert_match '🐧', @output.string
    assert_match '🍎', @output.string
    assert_match '💀', @output.string
    assert_match '🔥', @output.string
  end
end
