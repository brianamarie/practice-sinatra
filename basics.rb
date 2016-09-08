require 'rubygems'
require 'sinatra'
require 'json'

jsontest = "none"

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "I got some JSON: #{push.inspect}"
  jsontest = "I got some JSON: #{push.inspect}"
  load 'ruby addcollaborators -r githubteacher/all-the-hooks -i 1'
end

get '/' do
  jsontest
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
