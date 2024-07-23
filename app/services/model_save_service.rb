require 'rumale'

class ModelSaveService
  def initialize(model)
    @model = model
  end

  def save_model
    File.open('trained_models/linear_model.dat', 'wb') { |f| f.write(Marshal.dump(@model)) }
  end
end
