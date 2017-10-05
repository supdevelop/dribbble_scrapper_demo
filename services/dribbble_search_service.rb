require 'open-uri'
require 'nokogiri' # https://github.com/sparklemotion/nokogiri

class DribbbleSearchService
  def initialize(params)
    @core_url = 'https://dribbble.com'
    @query = params[:query]
  end

  def call
    html_doc = get_html("#{@core_url}/search?q=#{@query}")

    dribbbles = html_doc.css('li.group').map do |dribbble|
      next if dribbble.css('.dribbble .dribbble-shot .dribbble-img a.dribbble-over strong').text.empty?
      Dribbble.new(
        title:       dribbble.css('.dribbble .dribbble-shot .dribbble-img a.dribbble-over strong').text,
        description: dribbble.css('.dribbble .dribbble-shot .dribbble-img a.dribbble-over span.comment').text,
        author:      dribbble.css('.attribution .attribution-user a.url.hoverable').text,
        image_url:   dribbble.css('.dribbble .dribbble-shot div.dribbble-img a.dribbble-link picture img').attr('src'),
        url:         "#{@core_url}/#{dribbble.css('.dribbble .dribbble-shot .dribbble-img a.dribbble-over').attr('href')}"
      )
    end
    dribbbles.compact
  end

  private

  def get_html(url)
    html_file = open(url)
    Nokogiri::HTML(html_file)
  rescue SocketError => error
    puts "#{error.message}.\nVerify your connection... and retry!"
    nil
  end
end
