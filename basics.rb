require 'rubygems'
require 'sinatra'
require 'json'

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "I got some JSON: #{push.inspect}"
  exec 'addcollaborators -r brianamarie/travel-log -i 8'
end

get '/' do
  "Hello, World!"
end

get '/about' do
  "I'm Briana and I love waffles."
end

get '/hello/:name/' do
  "Hello there, #{params[:name]}."
end

get '/hello/:name/:city' do
  "Hey there #{params[:name]} from #{params[:city]}."
end
