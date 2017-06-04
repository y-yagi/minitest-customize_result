module Minitest
  def self.plugin_customize_result_init(opts)
    io = Minitest::CustomizeResult::Reporter.new(opts[:io])

    self.reporter.reporters.grep(Minitest::Reporter).each do |rep|
      rep.io = io
    end
  end
end
