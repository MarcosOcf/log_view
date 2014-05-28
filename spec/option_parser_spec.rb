require 'spec_helper'

describe LogView::OptParser do
  let :project_name do
    "project_name1"
  end

  before do
    LogView::Config.stub(:config_file_path).and_return("spec/fixtures/config.yml")
    config.load_project project_name
  end
  
  let :config do
    LogView::Config.new
  end

  let :args do
      [project_name, '--grep', 'string', '--split-log', '-s', 'test-server1', '-f', 'test-file1']
  end
  subject do
    LogView::OptParser.new.parse(args, config.load_project(project_name))
  end

  describe "#parse" do
    describe "with -n test" do
      let :args do
        [project_name, '-n', '100']
      end

      subject do
        LogView::OptParser.new.parse(args, config.load_project(project_name))
      end

      it "should create a string with -n args" do
        subject.grep_string.should eql " -n 100"
      end
    end

    describe "in grep test" do
      it "with a single word" do
        subject.grep_string.should eql " | grep --color=always 'string'"
      end
      
      describe "with a sentence separeted by spaces" do
        let :args do
          [project_name, '--grep', 'string to not match']
        end
        subject do
          LogView::OptParser.new.parse(args, config.load_project(project_name))
        end
        it "shoud return a string result" do
          subject.grep_string.should eql " | grep --color=always 'string to not match'"
        end
      end

    end

    describe "with --grep-v option" do
      
      let :args do
        [project_name, '--grep', 'string', '--grep-v', 'string']
      end
      describe "with a single word given" do
        it "grep-v test"  do
          subject.grep_string.should eql " | grep --color=always 'string' | grep -v 'string'"
        end
      end
      describe "with a given sentence" do
        let :args do
          [project_name, '--grep', 'string to match', '--grep-v', 'string to not match']
        end
        it "grep-v test"  do
          subject.grep_string.should eql " | grep --color=always 'string to match' | grep -v 'string to not match'"
        end
      end
    end

    it "split-log test" do
      subject.options.split_log.should eql true
    end

    describe 'choosing existent' do
      it "file test" do
        subject.options.if_files.should eql true
        subject.options.files.should eql 'test-file1'
      end

      it "servers test" do
        subject.options.if_server.should eql true
        subject.options.server.should eql 'test-server1'
      end
    end

    describe 'choosing inexistent' do
      let :args do
        [project_name, '--grep', 'string', '--split-log', '-s', 'test-server10', '-f', 'test-file10']
      end

      it 'file test' do
        subject.options.if_files.should eql true
        subject.options.files.should eql 'test-file10'
      end

      it 'server test' do
        subject.options.if_server.should eql true
        subject.options.server.should eql 'test-server10'
      end
    end
    describe 'using all options' do
      let :args do
        [project_name, '-n', '100', '--grep', 'string', '--grep-v', 'string', '--split-log', '-s', 'test-server1', '-f', 'test-file1']
      end
      it "should start with all choosen options" do
        subject.grep_string.should eql " -n 100 | grep --color=always 'string' | grep -v 'string"
      end
    end
  end
end