require "spec"
require "amber"

class Global
  @@response : HTTP::Client::Response?

  def self.response=(@@response)
  end

  def self.response
    @@response
  end
end

{% for method in %w(get head post put patch delete) %}
  def {{method.id}}(path, headers : HTTP::Headers? = nil, body : String? = nil)
    request = HTTP::Request.new("{{method.id}}".upcase, path, headers, body )
    request.headers["Content-Type"] = "application/x-www-form-urlencoded"
    Global.response = process_request request
  end
{% end %}

def process_request(request)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  main_handler = build_main_handler
  main_handler.call context
  response.close
  io.rewind
  client_response = HTTP::Client::Response.from_io(io, decompress: false)
  Global.response = client_response
end

def build_main_handler
  handler = Amber::Server.settings.handler
  handler.prepare_pipelines
  handler
end

def response
  Global.response.not_nil!
end
