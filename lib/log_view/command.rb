module LogView
  class Command
    include LogView::Colors

    def initialize config, argv = nil
      @config = config
      @array = argv.compact.map(&:strip).reject {|s| s.empty?}
    end

    def boot!
      if @array.nil? or @array.empty? or @array.include?("-h") or @array.include?("--help")
        puts help
        return
      end

      project_name = @array.first
      project_config = @config.load_project(project_name)
      project_opts = OptParser.new.parse @array, project_config

      do_ssh = DoTail.new(project_name, project_opts)

      trap("SIGINT") {
        print "\nClosing... "
        do_ssh.close
        print "that's all folks!\n"
        exit!
      }

      do_ssh.start
    end

    private
    def help
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

  end
end