require 'sigmoid'
require 'set'
require 'yaml'

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
      @outputs.each { |c| c.value = number.to_f }
    end
  end

  # ====

  class Connection
    attr_accessor :weight
    attr_reader :value, :input

    def initialize(dest, weight: rand(-1.0..1.0))
      @dest = dest
      @weight = weight
      @dest.add_input(self)
    end

    def value=(number)
      @input = number
      @value = (number.to_f * @weight)
      @dest.stimulate
    end
  end

  # ====

  class Neuron
    attr_accessor :inputs, :outputs
    attr_reader :value, :prev_error

    def initialize(learning_rate: 0.001, bias: 1)
      @inputs = Set.new
      @outputs = Set.new
      @activated_connections = 0
      @value = 0.0
      @learning_rate = learning_rate
      @bias = Connection.new(self)
      @bias.value = bias
    end

    def to_s
      {
        inputs: @inputs.map{|i| "#{i.input} : #{i.value} : #{i.weight}"},
        value: "#{value}"
      }.to_yaml
    end

    def add_input(source)
      @inputs << source
    end

    def connect(neuron, weight: rand(-1.0..1.0))
      con = Connection.new(neuron, weight: weight)
      @outputs << con
      return con
    end

    def stimulate
      activate and feed_forward if (@activated_connections += 1) >= @inputs.count - 1
    end

    def learn(desired)
      error = desired.to_f - @value
      @inputs.each { |input| input.weight += error * @learning_rate * input.input }
      return error
    end

    def activate
      @activated_connections = 0
      @value = squash(@inputs.reduce(0.0) { |sum, input| sum += input.value })
      return @value
    end

    def feed_forward
      @outputs.each { |o| o.value = @value }
    end

    def squash(value)
      Neural::Sigmoid.log(value)
    end
  end

end
