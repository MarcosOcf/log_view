module LogView
  class DoSSH
    include LogView::Colors

    def initialize project, obj_config
      @project = project.to_s
      @thread_array = []
      @should_close = false
      @obj_config = obj_config
    end

    def start
      each_server do |server|
        run_on_server(server) {|session, file|

          exec session, server, file

        }
      end
    end

    def close
      @should_close = true
      @thread_array.map(&:exit)
    end

    protected
    def execute_command server, channel, file
      raise NotImplementedError.new
    end

    private
    def each_server &block
      @obj_config.servers.each {|server| @thread_array << block.call(server)}
      @thread_array.map(&:join)
    end

    def run_on_server server, &block
      Thread.new {
        Net::SSH.start(server, @obj_config.user, password: @obj_config.password) do |session|
          @obj_config.files.each {|file| block.call(session, file)}
          session.loop { not @should_close }
        end
      }
    end

    def exec session, server, file
      session.open_channel do |channel|
        channel.request_pty do |ch|

          execute_command server, channel, file

        end
      end
    end

  end
end