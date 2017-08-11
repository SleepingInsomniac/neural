module Neural
  class Sigmoid
    # Squash a number to a value between 0 and 1
    # https://en.wikipedia.org/wiki/Sigmoid_function
    def self.log(value)
      1.0 / (1.0 + (Math::E ** -value.to_f))
    end
  end
end
