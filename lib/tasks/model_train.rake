require 'rumale'

namespace :model_linear_regression do
  desc "Train and evaluate model"
  task train: :environment do
    # Load the data
    data_loader_service = DataLoadService.new
    df = data_loader_service.load_data

    # # Convert the data to arrays of floats
    # features = df.map_rows do |row|
    #   [row[:temp].to_f, row[:humidity].to_f, row[:wspd].to_f]
    # end
    # target = df[:aqi].to_a.map(&:to_f)

    # x = Numo::DFloat[*features]
    # y = Numo::DFloat[*target]

    # Split the data
    data_splitter_service = DataSplitService.new
    split_data = data_splitter_service.split_data(df)

    # Train the model
    model_training_service = LinearRegressionTrain.new(split_data)
    model = model_training_service.train_model
    
    # model = Rumale::LinearModel::LinearRegression.new
    # model.fit(x, y)

    # Evaluate the model
    model_evaluation_service = ModelEvalService.new(model, split_data)
    evaluation = model_evaluation_service.evaluate_model

    puts "Model training and eval complete. Saving now. Check training log."
    # Save the model
    model_saving_service = ModelSaveService.new(model)
    model_saving_service.save_model
  end
end
