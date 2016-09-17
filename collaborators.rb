require 'octokit'

Octokit.auto_paginate = true

class Collaborator
  def self.add(repo_name:, issue_label:)
    # Get Issue Commenters and Add as Collaborators
    successfully_added_users = []
    current_collaborators = get_current_collaborators(repo_name)
    begin
      client.issues(repo_name, issue_label).each do |comment|
        username = comment[:user][:login]
        puts "adding #{username}"
        next if current_collaborators[username] # skip adding if already a collaborator
        if user_added = client.add_collaborator(repo_name, username)
          puts "added #{username}"
          successfully_added_users << username
        else
          puts "Failed to add #{username} as a collaborator (check: is githubteacher repository owner?)"
        end
      end
    rescue Octokit::NotFound
      abort "[404] - Repository not found:\nIf #{repo_name || "nil"} is correct, are you using the right Auth token?"
    rescue Octokit::UnprocessableEntity
      abort "[422] - Unprocessable Entity:\nAre you trying to add collaborators to an org-level repository?"
    end

    if successfully_added_users.any?
      begin
        names = "@#{successfully_added_users.first}"
        verb  = "is"
        num   = "a"
        noun  = "collaborator"

        if successfully_added_users.size > 1
          verb  = "are"
          num   = ""
          noun  = "collaborators"

          if successfully_added_users.size == 2
            names = "@#{successfully_added_users.first} and @#{successfully_added_users.last}"
          else
            at_mentions = successfully_added_users.map { |name| "@#{name}" }
            names = "#{at_mentions[0...-1].join(", ")}, and #{at_mentions[-1]}"
          end
        end

        message = ":tada: #{names} #{verb} now #{num} repository #{noun}. :balloon:"
        client.add_comment repo_name, issue_num, message
      rescue => e
        abort "ERR posting comment (#{e.inspect})"
      end
    end
  end

  def self.access_token
    ENV['GITHUBTEACHER_TOKEN'] || raise("You need a GitHub Teacher access token")
  end

  def self.client
    @_client ||= Octokit::Client.new :access_token => access_token
  end

  def self.get_current_collaborators(repo_name)
    Hash[client.collaborators(repo_name).map { |collaborator|
      [collaborator[:login], collaborator[:login]]
    }]
  end
end
