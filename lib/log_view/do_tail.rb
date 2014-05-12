module LogView
  class DoTail < DoSSH
    include LogView::Colors

    protected
    def execute_command server, channel, file
      channel.on_data {|ch, data| puts create_split(data, server, file)}
      puts channel.exec(" tail -f #{file}" + @obj_config.grep_string + "\n")
    end

    private
    def create_split data, server, file
      if @obj_config.options.split_log == true
        string = "\n[#{paint(32, server)}:#{paint(33,file)}]:\n#{data}\n"
      else
        string = ":\n#{data}\n"
      end

      string
    end
  end
end





