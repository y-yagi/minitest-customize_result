module Minitest
  module CustomizeResult
    class << self
      attr_reader :result_codes

      def use!(result_codes)
        @result_codes = {
          '.' => '.',
          'E' => 'E',
          'F' => 'F',
          'S' => 'S',
        }.merge!(result_codes)

        @use = true
      end

      def use?
        defined?(@use)
      end
    end

    class Reporter
      def initialize(io)
        @io = io
      end

      def print(o)
        if Minitest::CustomizeResult.use?
          @io.print(Minitest::CustomizeResult.result_codes[o])
        else
          @io.print(o)
        end
      end

      def method_missing msg, *args
        @io.send(msg, *args)
      end
    end
  end
end
