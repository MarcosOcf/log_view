require 'spec_helper'

describe LogView::Command do
  before do
    LogView::Config.stub(:config_file_path).and_return("spec/fixtures/config.yml")  
  end

  before do 
    LogView::DoTail.stub(:start).and_return true
  end

  let :config do
    LogView::Config.new
  end

  let :project_name do
    "project_name1"
  end

  let :args do
    [project_name, '--grep', nil, nil, nil,'string', nil, '--split-log'," " '-s', 'test-server1', '-f', 'test-file1']
  end

  describe 'initialize' do
    it 'teste' do
      #config = LogView::Config.new
      init = LogView::Command.new(config, args)
      init.instance_of?(LogView::Command).should eql true
    end
  end

  describe '#boot!' do
    subject do
      LogView::Command.new(config, args)
    end

    before do
      LogView::DoTail.stub(:start).and_return true
    end
    
    describe 'empty array' do
      subject do
        LogView::Command.new(config, [])
      end

      it 'should call help' do
        subject.boot!.should eql nil
      end
    end

    describe 'nil array' do
      subject do
        LogView::Command.new(config, [nil])
      end

      it 'should call help' do
        subject.boot!.should eql nil
      end
    end
    
    describe 'args array' do  
      subject do
        LogView::Command.new(config, args)
      end

      let :obj do
        double("DoTail")
      end

      before do
        obj.stub(:new).and_return(obj)
        obj.stub(:start).and_return(true)
      end

      before do
        LogView::DoTail.stub(:new).and_return(obj)
      end
      
      it 'should call start' do
        subject.boot!.should eql true      
      end
    end

    describe 'help' do

      before do
        LogView::Command.stub(:help).and_return true 
      end

      it 'Should call help function' do
        LogView::Command.send(:help).should eql true
      end
      
    end
  end
end