require 'numo/narray'

class DataSplitService
  def split_data(data_frame, test_size: 0.2)
    features = data_frame.map_rows do |row|
      [row[:temp].to_f, row[:humidity].to_f, row[:wspd].to_f]
    end
    target = data_frame[:aqi].to_a.map(&:to_f)

    x = Numo::DFloat[*features]
    y = Numo::DFloat[*target]

    n_samples = x.shape[0]
    n_test_samples = (n_samples * test_size).ceil
    n_train_samples = n_samples - n_test_samples

    indices = (0...n_samples).to_a.shuffle
    train_indices = indices.first(n_train_samples)
    test_indices = indices.last(n_test_samples)

    x_train = x[train_indices, true]
    y_train = y[train_indices]
    x_test = x[test_indices, true]
    y_test = y[test_indices]

    { x_train: x_train, y_train: y_train, x_test: x_test, y_test: y_test }
  end
end
