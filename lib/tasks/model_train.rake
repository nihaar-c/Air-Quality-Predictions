require 'rumale'

namespace :model do
  task :train, [:model_type, :model_filename] => :environment do |t, args|
    # Load the data
    data_loader_service = DataLoadService.new
    df = data_loader_service.load_data

    # Split the data
    data_splitter_service = DataSplitService.new
    split_data = data_splitter_service.split_data(df)

    # Train the selected model
    model_type = args[:model_type]
    model_training_service = case model_type
                             when 'linear_regression'
                               LinearRegressionTrain.new(split_data)
                             when 'svr'
                               SvrTrain.new(split_data)
                             when 'decision_tree'
                               DecisionTreeTrain.new(split_data)
                             when 'random_forest'
                               RandomForestTrain.new(split_data)
                             when 'gradient_boost'
                               GradientBoostTrain.new(split_data)
                             when 'xg_boost'
                               XGBoostTrain.new(split_data)
                             when 'ada_boost'
                               AdaptiveBoostTrain.new(split_data)
                             when 'knn'
                               KnnTrain.new(split_data)
                             when 'elastic_net'
                               ElasticNetTrain.new(split_data)
                             when 'mlp'
                               MlpNetTrain.new(split_data)
                             when 'ridge'
                               RidgeRegressionTrain.new(split_data)
                             when 'lasso'
                               LassoRegressionTrain.new(split_data)
                             when 'meta'
                               MetaModelTrain.new(split_data)
                             when 'temp_forest'
                               TempRandomForest.new(split_data)
                             else
                               raise "Unknown model type: #{model_type}"
                             end

    model = model_training_service.train_model

    TRAINING_LOGGER.info "------------- NEW TRAINING -------------"
    TRAINING_LOGGER.info "#{model_type} Model Evaluation Metrics:"
    # Evaluate the model
    model_evaluation_service = ModelEvalService.new(model, split_data)
    model_evaluation_service.evaluate_model

    puts "Model training and eval complete. Saving now. Check training log."
    # Save the model
    model_filename = args[:model_filename] || "#{model_type}_model.dat"
    save_model_service = ModelSaveService.new(model, model_filename)
    save_model_service.save_model
  end
end