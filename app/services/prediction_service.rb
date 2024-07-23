class PredictionService
  def initialize(model, data)
    @model = model
    @data = data
  end

  def make_predictions
    @model.predict(@data).to_a
  end
end