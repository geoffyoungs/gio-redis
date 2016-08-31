
$: << File.dirname(__FILE__)+'/../lib'
require 'test/unit'
require 'redis'
require 'gio/redis'

class GioTest < Test::Unit::TestCase
  def test_connect
    g = Gio::Redis.new
    sleep 0.2
    g.poll
    assert g.pong?, "Response received"
  end

  def test_message
    g = Gio::Redis.new
    r = ::Redis.new
    response = nil
    g.subscribe('gio-redis-test') { |_| response = _ }
    r.publish('gio-redis-test', 'All clear')
    sleep 0.2
    g.poll
    assert_equal "All clear", response, "Response received"
  end

  def test_hostname
    g = Gio::Redis.new('localhost')
    r = ::Redis.new
    response = nil
    g.subscribe('gio-redis-test') { |_| response = _ }
    r.publish('gio-redis-test', 'All clear')
    sleep 0.2
    g.poll
    assert_equal "All clear", response, "Response received"
  end
end

