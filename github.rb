require 'octokit'

print "Password: "
password = gets.chomp

github = Octokit::Client.new(login: "taylorzr", password: password)

puts github.user.inspect