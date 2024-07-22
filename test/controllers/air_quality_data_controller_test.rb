require "test_helper"

class AirQualityDataControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get air_quality_data_index_url
    assert_response :success
  end
end
