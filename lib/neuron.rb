require 'sigmoid'
require 'set'

module Neural

  class Input
    def initialize(*neurons)
      @outputs = Set.new
      neurons.each { |n| connect(n) }
    end

    def connect(neuron, weight: rand(-1.0..1.0))
      con = Connection.new(neuron, weight: weight)
      @outputs << con
      return con
    end

    def value=(number)
      # puts "\n#{self}: set #{number}"
      @outputs.each { |c| c.value = number.to_f }
    end
  end

  # ====

  class Connection
    attr_accessor :weight
    attr_reader :value

    def initialize(dest, weight: rand(-1.0..1.0))
      @dest = dest
      @weight = weight
      @dest.inputs << self
      # puts "Connection made: #{@weight}"
    end

    def value=(number)
      @value = number.to_f * @weight
      # puts "Input set: #{number} (#{@value})"
      @dest.stimulate
    end
  end

  # ====

  class Neuron
    attr_accessor :inputs, :outputs
    attr_reader :value, :prev_error

    def initialize(learning_rate: 0.001)
      @inputs = Set.new
      @outputs = Set.new
      @activated_connections = 0
      @value = 0.0
      @learning_rate = learning_rate
    end

    def connect(neuron, weight: rand(-1.0..1.0))
      con = Connection.new(neuron, weight: weight)
      @outputs << con
      return con
    end

    def stimulate
      activate and feed_forward if (@activated_connections += 1) >= @inputs.count
    end

    def learn(desired)
      error = desired.to_f - @value
      # print "\r#{"%.4f" % error}".rjust(12)
      # puts "Desired: #{desired}, error: #{error}"
      @inputs.each do |input|
        adjustment = @learning_rate * (error * input.value)
        # puts "\rAdjust: #{"%.3f" % input.weight} + #{"%.3f" % adjustment} = #{"%.3f" % (input.weight + adjustment)}"
        input.weight = squash(input.weight + adjustment)
      end
      return error
    end

    def activate
      @activated_connections = 0
      @value = squash(@inputs.reduce(0.0) { |sum, input| sum += input.value })
    end

    def feed_forward
      @outputs.each { |o| o.value = @value }
    end

    def squash(value)
      Neural::Sigmoid.log(value)
    end
  end

end
