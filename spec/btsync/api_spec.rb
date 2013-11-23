require 'spec_helper'
require_relative '../../lib/btsync/api.rb'

describe Btsync::Api do

  let(:api) { Btsync::Api.new }

  before(:each) do
    Net::HTTP.stub(:get).and_return('{"error": 0}')
  end

  describe "#initialize" do
    it "sets a default port and host if none are given" do
      api.settings[:host].should == 'localhost'
      api.settings[:port].should == 8888
    end
  end
  
  describe "#execute" do

    it "uses GET to call the API" do
      Net::HTTP.should_receive(:get)
      api.execute('my_method')
    end

    it "sends the method as a parameter" do
      URI.should_receive(:encode_www_form).with(method: 'my_method')
      api.execute('my_method')
    end

    it "adds options as additional parameters" do
      URI.should_receive(:encode_www_form).with(method: 'my_method', foo: 'bar', baz: 'foo')
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
      Net::HTTP.should_receive(:get).and_return('{ "error": 1, "message": "Invalid API method name or format." }')
      expect{
        api.unkown_method
      }.to raise_error(NoMethodError)
    end

    it "passes exceptions other than method not found through" do
      Net::HTTP.should_receive(:get).and_return('{ "error": 2, "message": "Specify all the required parameters for get_files." }')
      expect{
        api.get_files
      }.to raise_error(Btsync::ApiError)
    end
  end
end