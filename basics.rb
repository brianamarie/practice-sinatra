require 'rubygems'
require 'sinatra'
require 'json'
require_relative 'collaborators'

jsontest = "none"

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "I got some JSON: #{push.inspect}"
  jsontest = "I got some JSON: #{push.inspect}"
  Collaborator.add repo_name: "githubschool/open-enrollment-classes-introduction-to-github", issue_num: 927
  Collaborator.add repo_name: "githubteacher/oct-20", issue_num: 1
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
