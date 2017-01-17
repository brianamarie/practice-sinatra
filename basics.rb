require 'rubygems'
require 'sinatra'
require 'json'
require_relative 'collaborators'

jsontest = "none"

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "I got some JSON: #{push.inspect}"

  Collaborator.addByIssue repo_name: push["repository"]["full_name"].to_s, issue_num: push["issue"]["number"].to_i, user_login: push["issue"]["user"]["login"].to_s

  Collaborator.add repo_name: "githubschool/on-demand-github-pages", issue_num: 1
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
