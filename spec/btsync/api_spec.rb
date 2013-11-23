require 'spec_helper'
require_relative '../../lib/btsync/api.rb'

describe BtsyncApi::Api do

  let(:api) { BtsyncApi::Api.new }

  before(:each) do
    api.stub(:do_request).and_return({"error" => 0})
  end

  describe "#initialize" do
    it "sets a default port and host if none are given" do
      api.settings[:host].should == 'localhost'
      api.settings[:port].should == 8888
    end
  end
  
  describe "#execute" do

    it "calls the API" do
      api.should_receive(:do_request).and_return({})
      api.execute('my_method')
    end

    it "merges the options as additional parameters" do
      api.should_receive(:do_request).with(method: 'my_method', foo: 'bar', baz: 'foo')
      api.execute('my_method', foo: 'bar', baz: 'foo')
    end
  end

  describe "#method_missing" do

    it "tries to send a missing method to the API" do
      api.should_receive(:execute).with(:foobar)
      api.foobar
    end

    it "hands the parameters over to #execute" do
      api.should_receive(:execute).with(:foobar, {foo: 'bar', other: 'argument'})
      api.foobar(foo: 'bar', other: 'argument')
    end

    it "allows empty options" do
      expect{
        api.valid_method
      }.to_not raise_error
    end

    it "calls super if the method is not found" do
      api.should_receive(:do_request).and_return({ "error" => 1, "message" => "Invalid API method name or format." })
      expect{
        api.unkown_method
      }.to raise_error(NoMethodError)
    end

    it "passes exceptions other than method not found through" do
      api.should_receive(:do_request).and_return({ "error" => 2, "message" => "Specify all the required parameters for get_files." })
      expect{
        api.get_files
      }.to raise_error(BtsyncApi::ApiError)
    end
  end
end