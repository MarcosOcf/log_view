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
      @options.if_help = false
      @options.if_grepv = false
      @options.if_n = false
    end

    def new_opt_parser options
      OptionParser.new do |opts|
        opts.on("--grep","--grep string", String) {|grep|
          options.grep = true
          options.grep_string = grep
        }
        opts.on("--grep-v", "--grep-v string", String){ |grep|
          options.grep_v = true
          options.grep_v_string = grep
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
        opts.on("--help"){
          options.if_help = true
        }
        opts.on("-h"){
          options.if_help = true 
        }
        opts.on("-n","--n string", String){ |line_number|
          options.if_n = true
          options.line_numbers = line_number
        }
      end
    end

    def generate_config config
      config.tap do |conf|
        conf.options = @options
        create_n_lines conf
        create_grep conf
        create_grepv conf
        create_files conf
        create_servers conf
        puts_help conf if conf.options.if_help == true
      end
    end

    def puts_help
      array = []
      array << "LogView version #{VERSION}"
      array << "Configuration file at: #{paint_green(Config.config_file_path)}"
      array << "Projects:"
      projects = @config.projects || []
      if projects.empty?
        array << "  No projects configured, please take a look at the configuration file"
      else
        projects.each do |project|
          array << "  - #{project}"
        end
      end
      array << "\nHelp:"
      array << "  $ log_view <project_name>"
      array << "\n"
      array << "  $ log_view <project_name>  --grep <string-name>"
      array << "\n"
      array << "  $ log_view <project_name>  --split-log"
      array << "\n"
      array << "  $ log_view <project_name>  -s <server-name>"
      array << "\n"
      array << "  $ log_view <project_name>  -f <file-name>"
      array << "\n"
      array.join("\n")
    end

    def create_n_lines config
      config.grep_string = ""
      config.grep_string << " -n #{config.options.line_numbers}" if config.options.if_n
    end

    def create_grepv config
      config.grep_string << " | grep -v #{config.options.grep_v_string}" if config.options.grep_v
    end

    def create_grep config
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