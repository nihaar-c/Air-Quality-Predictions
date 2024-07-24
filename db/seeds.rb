# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'net/http'
require 'json'
require 'uri'

def fetch_image_url(city, state)
    def fetch_from_wikipedia(title)
      encoded_title = URI.encode_www_form_component(title)
      url = "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&prop=pageimages|pageterms&piprop=thumbnail&pithumbsize=600&titles=#{encoded_title}"
  
      uri = URI(url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
  
      pages = data.dig('query', 'pages')
      page = pages.first
      page.dig('thumbnail', 'source')
    end
  
    # Try with city and state
    image_url = fetch_from_wikipedia("#{city}, #{state}")
  
    # If no image, try with city only
    image_url ||= fetch_from_wikipedia(city)
  
    image_url
  end

cities = [
  { name: 'New York City', state: 'New York', population_estimate: 8335897, population_census: 8804190 },
  { name: 'Los Angeles', state: 'California', population_estimate: 3822238, population_census: 3898747 },
  { name: 'Chicago', state: 'Illinois', population_estimate: 2665039, population_census: 2746388 },
  { name: 'Houston', state: 'Texas', population_estimate: 2302878, population_census: 2304580 },
  { name: 'Phoenix', state: 'Arizona', population_estimate: 1644409, population_census: 1608139 },
  { name: 'Philadelphia', state: 'Pennsylvania', population_estimate: 1567258, population_census: 1603797 },
  { name: 'San Antonio', state: 'Texas', population_estimate: 1472909, population_census: 1434625 },
  { name: 'San Diego', state: 'California', population_estimate: 1381162, population_census: 1386932 },
  { name: 'Dallas', state: 'Texas', population_estimate: 1299544, population_census: 1304379 },
  { name: 'Austin', state: 'Texas', population_estimate: 974447, population_census: 961855 },
  { name: 'Jacksonville', state: 'Florida', population_estimate: 971319, population_census: 949611 },
  { name: 'San Jose', state: 'California', population_estimate: 971233, population_census: 1013240 },
  { name: 'Fort Worth', state: 'Texas', population_estimate: 956709, population_census: 918915 },
  { name: 'Columbus', state: 'Ohio', population_estimate: 907971, population_census: 905748 },
  { name: 'Charlotte', state: 'North Carolina', population_estimate: 897720, population_census: 874579 },
  { name: 'Indianapolis', state: 'Indiana', population_estimate: 880621, population_census: 887642 },
  { name: 'San Francisco', state: 'California', population_estimate: 808437, population_census: 873965 },
  { name: 'Seattle', state: 'Washington', population_estimate: 749256, population_census: 737015 },
  { name: 'Denver', state: 'Colorado', population_estimate: 713252, population_census: 715522 },
  { name: 'Oklahoma City', state: 'Oklahoma', population_estimate: 694800, population_census: 681054 },
  { name: 'Nashville', state: 'Tennessee', population_estimate: 683622, population_census: 689447 },
  { name: 'El Paso', state: 'Texas', population_estimate: 677456, population_census: 678815 },
  { name: 'Washington, D.C.', state: 'District of Columbia', population_estimate: 671803, population_census: 601723 },
  { name: 'Las Vegas', state: 'Nevada', population_estimate: 656274, population_census: 641903 },
  { name: 'Boston', state: 'Massachusetts', population_estimate: 650706, population_census: 675647 }
]

cities.each do |city|
  image_url = fetch_image_url(city[:name], city[:state])
  City.create(
    name: city[:name],
    state: city[:state],
    population_estimate: city[:population_estimate],
    population_census: city[:population_census],
    image_url: image_url
  )
end
