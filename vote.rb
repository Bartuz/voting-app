require 'sinatra'
require 'pry'
require 'yaml/store'

Choices = {
  HAM: 'Hamburger',
  PIZ: 'Pizza',
  CUR: 'Curry',
  NOO: 'Noodles'
}

get '/' do
  @title = "Głosuj!"
  erb :index
end

post '/cast' do
  wybor = "#{Choices[params['vote'].to_sym]}"
  
  @store = YAML::Store.new 'votes.yml'

  @store.transaction do
    @store['votes'] ||= {}
    @store['votes'][wybor] ||= 0
    @store['votes'][wybor] += 1
  end

  @title = "dziękuje za oddanie głosu #{wybor}"
  erb :cast
end

get '/results' do
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end

