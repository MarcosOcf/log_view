require 'spec_helper'

describe LogView::DoTail do 

  let :project do
    'project_name1'
  end

  let :data do
    'data_string_exemple'
  end

  let :server do
    'test-server1'
  end

  let :file do
    'test-file1'
  end

  describe "initialize" do
    let :project do
      "choosen_project"
    end
    let :obj_config do
      "configures_object"
    end

    subject do
      LogView::DoTail.new project, obj_config
    end

    it "should return instance_of DoTail" do
      dotail = LogView::DoTail.new project, obj_config
      dotail.instance_of?(LogView::DoTail).should eql true
    end
  end
  
  describe "create_split" do

    let :obj_config do
      OpenStruct.new
    end

    let :options do
      OpenStruct.new
    end

    before do
      options.split_log = true
      obj_config.options = options
    end
    subject do
      LogView::DoTail.new project, obj_config
    end
    COLOR_CODES = {
      green:      32,
      yellow:     33
    }

    def paint color_code, string
      "\e[#{color_code}m#{string}\e[0m"
    end

    it 'should split LogView by server and file' do
      subject.send(:create_split, data, server, file).should eql "\n[#{paint(32, server)}:#{paint(33,file)}]:\n#{data}\n"
    end
  end

  describe 'execute_command' do
    
    let :obj_config do
      OpenStruct.new
    end
    
    subject do
      LogView::DoTail.new project, obj_config
    end
    
    let :create_split do
      double "create_split"
    end

    let :channel do
      double "channel"
    end

    let :data do
      double "data"
    end

    let :test_string do
      ' grep string test '
    end

    before do
      obj_config.grep_string = ''
    end

    before do
      channel.stub(:on_data).and_return true
      channel.stub(:exec).and_return test_string
      STDOUT.should_receive(:puts).with(test_string)
    end

    it 'should call create_split 1 time' do
      subject.send(:execute_command, server, channel, file)
    end

  end
end





