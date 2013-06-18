require "gio/redis/version"
require 'gio2'
require 'hiredis/reader'

module Gio
  class Redis
    # Your code goes here...
    def initialize(host = '127.0.0.1', port = 6379, mainloop = nil)

      @addr = Gio::InetSocketAddress.new(Gio::InetAddress.new_from_string(host), port)
      @sock =  Gio::Socket.new(:ipv4, :stream, :tcp)

      @sock.connect(@addr)
      @sock.set_blocking(false)

      @reader = Hiredis::Reader.new

      @source = @sock.create_source(GLib::IOCondition::IN, &method(:read_response))
      @source.attach
      @pong = false
      @callbacks = {}
      call_command 'PING'
    end

    def pong?
      @pong
    end

    def subscribe(channel, &block)
      (@callbacks[channel] ||= []) << block
      call_command("SUBSCRIBE", channel)
    end

    def unsubscribe(channel)
      @callbacks.delete(channel)
      call_command("UNSUBSCRIBE", channel)
    end

    def poll
      read_response
    end

  private
    def call_command(*args)
      command = "*#{args.size}\r\n"
      args.each { |a|
        command << "$#{a.to_s.size}\r\n"
        command << a.to_s
        command << "\r\n"
      }
      @sock.send command
    end

    def read_response(source=nil, condition=nil)
      while data = read(4096)
        @reader.feed(data)

        while response = @reader.gets
          case response
          when 'PONG'
            @pong = true
          when Array
            case response[0]
            when 'subscribe', 'unsubscribe'
            when 'message'
              type, channel, data = *response
              for cb in (@callbacks[channel]||[])
                cb.call(data)
              end
            else
              STDERR.puts "Unexpected response: #{response.inspect}"
            end
          end
        end
      end
      true
    end

    def read(n)
      @sock.receive(n)
    rescue Gio::IO::WouldBlockError => e
      nil
    end
  end
end
