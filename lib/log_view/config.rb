module LogView
  class Config
    extend Forwardable

    CONFIG_FILE_NAME = ".log_view.yml"
    CONFIG_SAMPLE = %Q{
# This is a sample, please fill the options with your own configurations
# 
#
# project_name:
#   user: my_ssh_user
#   password: my_ssh_password
#   servers:
#     - some_name@some_server.com
#   files:
#     - "/log/dir/my_log_file.log"
#
}
    def_delegators :@project, :user, :password, :servers, :files
    attr_reader :projects

    def initialize
      path = Config.config_file_path
      File.open(path, "w") {|f| f.write(CONFIG_SAMPLE)} unless File.exists?(path)

      hash = YAML.load_file(path)
      @projects = hash ? hash.keys : []
      @config = OpenStruct.new(hash)
    end

    def load_project name
      project_config = @config.send("#{name}")       
      OpenStruct.new(project_config)
    end

    def self.config_file_path
      File.join(Dir.home, CONFIG_FILE_NAME)
    end
  end
end