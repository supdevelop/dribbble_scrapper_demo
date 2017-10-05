require 'open-uri'
require 'nokogiri'
require 'sinatra'

get '/' do
  erb :'home'
end

get '/search' do
  @cards = []

  search_url = "https://dribbble.com/search?q=wagon" # <= customize

  html_file = open(search_url)
  html_document = Nokogiri::HTML(html_file)

  collection_css_path = 'li.group' # <= customize
  collection = html_document.css(collection_css_path)

  collection.each do |element|
    #title
    title_css_path = '.dribbble .dribbble-shot .dribbble-img a.dribbble-over strong' # <= customize
    title = element.css(title_css_path).text

    # skip if it's not a real card
    unless title.empty?
      # url
      relative_url_css_path = '.dribbble .dribbble-shot .dribbble-img a.dribbble-over' # <= customize
      relative_url = element.css(relative_url_css_path).attr('href')
      absolute_url = "https://dribbble.com/#{relative_url}" # <= customize
      # or
      # absolute_url = "https://dribbble.com/" + relative_url

      # image
      image_url_css_path = '.dribbble .dribbble-shot div.dribbble-img a.dribbble-link picture img' # <= customize
      image_url = element.css(image_url_css_path).attr('src')

      @cards << [title, absolute_url, image_url]
    end
  end

  erb :'search'
end
