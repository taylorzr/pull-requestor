require 'octokit'

## Collect git info

  # if not configured?
  github_username = `git config github.user`.chomp

  # if not in git project?
  git_remote = `git remote -v | grep origin | grep "\(push\)" | egrep -o "/[^/]+/[^/]+['.git']" | egrep -o ".+[^'.git']"`.chomp
  _, remote_username, remote_repo = git_remote.split("/")
  base_branch = "master"
  current_branch = `git branch | grep "\*" | grep -o "[^'* '].*"`.chomp
  puts "  Making merge request for #{current_branch} -> #{base_branch} @ #{remote_username}/#{remote_repo}"


## Get user input

  print "  Password: "
  password = gets.chomp

  github = Octokit::Client.new(login: "taylorzr", password: password)

  message = ""
  while message == ""
    print "  Message for pull-request: "
    message = gets.chomp
    puts "  Error: Message can not be blank" if message == ""
  end


## Make pull request
  begin
    pull_request = github.create_pull_request(
      "#{github_username}/#{remote_repo}", 
      "master", 
      "#{current_branch}", 
      "#{message}", 
      ""
    )
    puts "  Success: Pull request made!"
  rescue StandardError => error
    if error.class == Octokit::UnprocessableEntity
      puts "  Error: A pull-request from this branch already exists"
    elsif error.class == Octokit::Unauthorized
      puts "  Error: Invalid password"
    else
      puts "  Error: #{error}"
    end
  end