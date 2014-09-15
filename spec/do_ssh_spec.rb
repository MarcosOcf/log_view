require 'spec_helper'

describe LogView::DoSSH do

  let :project do
    'project_name1'
  end

  let :obj_config do
    double "obj_config"
  end

  subject do
    LogView::DoSSH.new project, obj_config
  end

  describe "initialize" do

    it "should configure project" do
      subject.instance_variable_get(:@project).should eql 'project_name1'
    end
    it "should define should_close false" do
      subject.instance_variable_get(:@should_close).should eql false
    end
  end

  describe "close function" do

    let :thread1 do
      double "Thread.new"
    end

    let :thread2 do
      double "Thread.new"
    end

    describe "on first step" do

      it "should define should_close true" do
        subject.close
        subject.instance_variable_get(:@should_close).should eql true
      end
    end

    describe "on second step" do

      before do
        thread1.should_receive(:exit)
        thread2.should_receive(:exit)
      end

      it "should call exit for all threads" do
        subject.instance_variable_set(:@thread_array, [thread1, thread2])
        subject.close
      end
    end
  end
end









