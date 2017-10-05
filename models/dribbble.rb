class Dribbble
  attr_reader :title, :description, :author, :image_url, :url

  def initialize(params)
    @title       = params[:title]
    @description = params[:description]
    @author      = params[:author]
    @image_url   = params[:image_url]
    @url         = params[:url]
  end
end
