require 'sinatra'

require_relative 'models/dribbble'
require_relative 'services/dribbble_search_service'

get '/' do
  erb :'home', layout: :'layouts/application'
end



get '/search' do
  @dribbbles = DribbbleSearchService.new(query: params[:query]).call

  erb :'dribbbles/index', layout: :'layouts/application'
end
