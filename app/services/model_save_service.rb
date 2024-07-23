class ModelSaveService

  def initialize(model, filename)
    @model = model
    @filename = filename
  end

  def save_model
    File.open("trained_models/#{@filename}", 'wb') do |f|
      f.write(Marshal.dump(@model))
    end
  end
end
