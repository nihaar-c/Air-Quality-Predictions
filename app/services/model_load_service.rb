class ModelLoadService
  
  def initialize(filename)
    @filename = filename
  end

  def load_model
    require 'rumale'
    file_path = Rails.root.join("trained_models", @filename)
    if File.exist?(file_path)
      File.open(file_path, "rb") {
        |f| Marshal.load(f)
      }
    else
      raise "Model file not found: #{@filename}"
    end
  end
end

