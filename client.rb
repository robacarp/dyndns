require 'net/http'
require 'debugger'

load 'hasher.rb'

url = URI("http://localhost:4567/")

begin
  request = Net::HTTP.get_response url
  token = request["X-Hash-Me"]

  if token.nil? || token.length != 64
    puts "couldn't verify call"
    debugger
    exit(1)
  end

  response = Hasher.pepper token
  request = Net::HTTP.post_form(url, {
    call: token,
    response: response
  })

  if request.code.to_i != 200
    print "update failed: "
  else
    print "update succeeded: "
  end
  puts request.body

rescue Errno::ECONNREFUSED
  puts "connection refused"
rescue Net::ReadTimeout
  puts "connection timeout"
end
