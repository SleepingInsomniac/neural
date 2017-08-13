require 'neuron'
require 'yaml'

module Neural
  class Brain

    def self.default_save_path
      "save/#{name.split('::').last}.yml"
    end

    def self.load(path = default_save_path)
      @path = path
      File.exists?(path) ? YAML.load(File.read(@path)) : self.compose
    end

    def self.compose
      new
    end

    attr_accessor :inputs, :neurons

    def initialize(inputs: {}, neurons: {})
      @inputs = inputs
      @neurons = neurons
    end

    def perceive(**perceptions)
      perceptions.each_pair do |input, value|
        @inputs[input].value = value
      end
    end

    def learn(**n)
      errors = []
      n.each_pair do |name, expectation|
        errors.push @neurons[name].learn(expectation)
      end
      return errors
    end

    def save(path = nil)
      @path = path || @path || self.class.default_save_path
      `mkdir -p #{File.dirname @path}`
      File.open(@path, 'w') do |file|
        file.write YAML.dump(self)
      end
      self
    end
  end
end
