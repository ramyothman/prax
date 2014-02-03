ENV['PRAX_HOST_ROOT'] = File.expand_path('../hosts', __FILE__)
ENV['PRAX_HTTP_PORT'] = '20557'
ENV['PRAX_HTTPS_PORT'] = '20556'

gem 'minitest', '~> 4.0'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'timeout'
require 'socket'

gem 'minitest-colorize'
require 'minitest-colorize'

$:.unshift File.expand_path("../../lib", File.realpath(__FILE__))
Thread.abort_on_exception = true

class Minitest::Spec
  let(:prax_env) do
    {
      'PRAX_HOST_ROOT' => File.expand_path('../hosts', __FILE__),
      'PRAX_DEBUG' => "1",
    }
  end

  let(:prax_cmd) do
    "#{File.expand_path('../../bin/prax', __FILE__)} start --foreground"
  end

  before do
    _, out, _, @thr = Open3.popen3(prax_env, prax_cmd)
    while line = out.gets
      break if line =~ /Prax is ready/
    end
  end

  after { Process.kill(@thr[:pid]) rescue nil }

  #def client(type, hostname, port = nil, &block)
  #  case type
  #  when :tcp  then tcp_client(hostname,  port, &block)
  #  when :ssl  then ssl_client(hostname,  port, &block)
  #  when :unix then unix_client(hostname, &block)
  #  end
  #end

  #def tcp_client(hostname, port)
  #  socket = TCPSocket.new(hostname, port)
  #  yield socket if block_given?
  #ensure
  #  socket.close if socket
  #end

  #def unix_client(path)
  #  socket = UNIXSocket.new(path)
  #  yield socket if block_given?
  #ensure
  #  socket.close if socket
  #end

  #def ssl_client(hostname, port)
  #  tcp_client(hostname, port) do |tcp|
  #    socket = OpenSSL::SSL::SSLSocket.new(tcp, ssl_context)
  #    socket.sync_close = true
  #    socket.connect
  #    yield socket if block_given?
  #  end
  #end

  #def ssl_context
  #  @ssl_context ||= begin
  #    ctx      = OpenSSL::SSL::SSLContext.new
  #    path     = File.expand_path('../ssl', __FILE__)
  #    ctx.cert = OpenSSL::X509::Certificate.new(File.read(File.join(path, 'client.crt')))
  #    ctx.key  = OpenSSL::PKey::RSA.new(File.read(File.join(path, 'client.key')))
  #    ctx
  #  end
  #end
end
