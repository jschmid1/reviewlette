require 'debugger'
require 'yaml'
require 'octokit'

module Reviewlette
  class GithubConnection
    GITHUB_CONFIG = YAML.load_file('/home/jschmid/reviewlette/config/.github.yml')
    attr_accessor :client, :repo

    def initialize
      gh_connection
    end

    def gh_connection
      @repo = 'jschmid1/reviewlette'
      @client = Octokit::Client.new(:access_token => GITHUB_CONFIG['token'])
    end

    def pull_merged?(repo, number)
      @client.pull_merged?(repo, number)
    end

    def add_assignee(number, title, body, name)
      @client.update_issue("#{@repo}", "#{number}", "#{title}", "#{body}",{:assignee => "#{name}"})
      @client.add_comment("#{@repo}", "#{number}", "#{name} is your reviewer :thumbsup: ")
    end

    def determine_assignee(repo)
      @client.list_issues(repo).each do |a|
        unless a[:assignee]
          @number = a[:number]
          @title = a[:title]
          @body = a[:body]
        end
      end
    end

    def move_card_to_list(card, repo, number)
      if pull_merged?(repo, number)
        card.move_to_list(find_column('Done').id)
        puts "moved to #{find_column('Done').name}"
      else
        card.move_to_list(find_column('in-review').id)
        puts "moved to #{find_column('in-review').name}"
      end
    end

    def assignee?(card)
      if find_card(@title)
        add_assignee(@number, @title, @body)
        move_card_to_list(card, @repo, @number) if add_reviewer_to_card(card)
      else
        puts "Card not found for title #{@title.inspect}"
      end
    end

  end
end
