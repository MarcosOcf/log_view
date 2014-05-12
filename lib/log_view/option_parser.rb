module LogView
  class OptParser
    include LogView::Colors

    def initialize
      @options = OpenStruct.new
      apply_defaults
    end

    def parse args, config
      opt_parser = new_opt_parser @options
      opt_parser.parse!(args)
      generate_config config
    end

    private
    def apply_defaults
      @options.grep = false
      @options.split_log = false
      @options.if_files = false
      @options.if_server = false
    end

    def new_opt_parser options
      OptionParser.new do |opts|
        opts.on("--grep","--grep string", String) {|grep|
          options.grep = true
          options.grep_string = grep
        }

        opts.on("--split-log") {
          options.split_log = true
        }

        opts.on("-f","--file string", String) {|file|
          options.if_files = true
          options.files = file
        }

        opts.on("-s", "--server string", String) {|server|
          options.if_server = true
          options.server = server
        }
      end
    end

    def generate_config config
      config.tap do |conf|
        conf.options = @options
        create_grep conf
        create_files conf
        create_servers conf
      end
    end

    def create_grep config
      config.grep_string = ""
      config.grep_string << " | grep --color=always #{config.options.grep_string}" if config.options.grep
    end

    def create_files config
      return unless config.options.if_files

      config.files = config.files.select {|file| file.include?(config.options.files.to_s)}
      puts paint_red("\tWarning -- no files with #{config.options.files.to_s}") if config.files.empty?
    end

    def create_servers config
      return unless config.options.if_server

      config.servers = config.servers.select {|server| server.include?(config.options.server.to_s)}
      puts paint_red("\tWarning -- no servers with #{config.options.server.to_s}") if config.servers.empty?
    end
  end
end