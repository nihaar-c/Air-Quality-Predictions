class DemoController < ApplicationController
  def index
    @cities = City.all
  end
end
