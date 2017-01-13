require 'octokit'

Octokit.auto_paginate = true

class Collaborator
  def self.add(repo_name:, issue_num:, user_login:)
    begin
      current_collaborators = get_current_collaborators(repo_name)

      if current_collaborators.has_value?(user_login)
        puts "#{user_login} is already a collaborator."
      else
        if user_added = client.add_collaborator(repo_name, user_login)
          message = ":tada: @#{user_login} you are now a repository collaborator. :balloon:"

          client.add_comment repo_name, issue_num, message

          puts message
        else
          puts "Failed to add #{user_login} as a collaborator (check: is githubteacher repository owner?)"
        end
      end
    rescue Octokit::NotFound
      abort "[404] - Repository not found:\nIf #{repo_name || "nil"} is correct, are you using the right Auth token?"
    rescue Octokit::UnprocessableEntity
      abort "[422] - Unprocessable Entity:\nAre you trying to add collaborators to an org-level repository?"
    end
  end

  def self.get_current_collaborators(repo_name)
    Hash[client.collaborators(repo_name).map { |collaborator|
      [collaborator[:login], collaborator[:login]]
    }]
  end

  def self.access_token
    ENV['GITHUBTEACHER_TOKEN'] || raise("You need a GitHub Teacher access token")
  end

  def self.client
    @_client ||= Octokit::Client.new :access_token => access_token
  end
end
