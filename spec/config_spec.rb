require 'spec_helper'

describe LogView::Config do

  describe "initialize" do
    describe "if file exists" do
      before do
        LogView::Config.stub(:config_file_path).and_return("spec/fixtures/config.yml")
      end

      subject do
        LogView::Config.new
      end

      it "projects" do
        subject.projects.should eql ["project_name1", "project_name2"]
      end
    end

    describe "if file not exists" do
      before do
        LogView::Config.stub(:config_file_path).and_return("spec/fixtures/config2.yml")
      end

      after do
        FileUtils.rm_f "spec/fixtures/config2.yml"
      end

      it "projects" do
        subject.projects.should eql []
      end
    end
  end

  describe "#load_project" do
    before do
      LogView::Config.stub(:config_file_path).and_return("spec/fixtures/config.yml")
    end

    let :config do
      LogView::Config.new
    end

    let :project_name do
      "project_name1"
    end

    subject do
      config.load_project project_name
    end

    it "attributes test" do
      subject.should_not be_nil
      subject.should respond_to :user
      subject.should respond_to :password
      subject.should respond_to :servers
      subject.should respond_to :files
      subject.user.should eql "a"
      subject.password.should eql "b"
      subject.files.should eql ["test-file1","test-file2"]
      subject.servers.should eql ["test-server1","test-server2"]
    end
  end
  describe "config_file_path" do
    let :home_path do
      "/home/do/usuario"
    end

    before do
      Dir.stub(:home).and_return(home_path)
    end
    
    it "test of directories" do
      LogView::Config.config_file_path.should eql "#{home_path}/#{LogView::Config::CONFIG_FILE_NAME}"
    end
  end
end














