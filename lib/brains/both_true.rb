require 'brain'

class BothTrue < Neural::Brain
  BRAIN_FILE = File.join(__dir__, 'brain.yml')

  def self.load
    if File.exists?(BRAIN_FILE)
      super(BRAIN_FILE)
    else
      self.compose
    end
  end

  def self.compose
    if File.exists?(BRAIN_FILE)
      brain = self.load(BRAIN_FILE)
    else
      input_1 = Neural::Input.new
      input_2 = Neural::Input.new
      neuron = Neural::Neuron.new

      input_1.connect(neuron)
      input_2.connect(neuron)

      brain = new( 
        inputs: { one: input_1, two: input_2 },
        neurons: { n: neuron }
      ).save
    end
    return brain
  end

  def save
    super(BRAIN_FILE)
  end

  def both_true?
    @neurons[:n].value > 0.5
  end

  def train
    r1 = [-1, 1].sample
    r2 = [-1, 1].sample

    perceive(one: r1, two: r2)
    return learn(r1 + r2 == 2 ? {n: 1} : {n: 0})
  end
end