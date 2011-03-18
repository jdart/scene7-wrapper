require 'spec_helper'

describe Scene7::Client do
  subject { Scene7::Client }
  let(:valid_config_params) { ['test-instance', 'test@example.com', 'password', 'MyAppName', '1.2'] }
  let(:valid_config_hash) { {:subdomain => 'test-instance', :user => 'test@example.com', :password => 'password', :app_name => 'MyAppName', :app_version => '1.2' } }

  describe ".configure" do
    it "sets the configuration" do
      Scene7::Config.expects(:new).with(*valid_config_params).returns('my config')
      subject.configure(valid_config_hash)

      subject.configuration.should == 'my config'
    end

    it "returns the Scene7::Client class" do
      subject.configure(valid_config_hash).should == Scene7::Client
    end
  end

  describe '.reset_configuration' do
    it "resets the configuration by setting it to nil" do
      Scene7::Config.expects(:new).with(*valid_config_params).returns('my config')
      subject.configure(valid_config_hash)

      subject.reset_configuration

      subject.configuration.should be_nil
    end
  end

  describe '.header' do
    it "delegates to the configuration" do
      subject.configure(valid_config_hash)
      subject.configuration.expects(:header).returns('the header')
      subject.header.should == 'the header'
    end

    it 'blows up if there is no configuration' do
      expect { subject.header }.to raise_error('Call Scene7::Client.configure with your configuration first.')
    end
  end

  describe '.perform_request' do
    before { subject.configure(valid_config_hash) }
    it 'performs a SOAP call through the Savon client' do
      savon.expects(:get_company_info).with(:company_name => 'test').returns(:test_request)

      subject.perform_request(:get_company_info, :company_name => 'test').to_xml.chomp.should == "<myxml />"
    end
  end

  describe ".client" do
    let(:scene7_client) { Scene7::Client.configure(valid_config_hash) }
    subject { scene7_client.client }

    it "is a Savon::Client object" do
      subject.should be_a(Savon::Client)
    end

    it "has the appropriate namespace" do
      subject.wsdl.namespace.should == "http://www.scene7.com/IpsApi/xsd/2010-01-31"
    end

    it "has the appropriate endpoint" do
      subject.wsdl.endpoint.should == "https://test-instance.scene7.com/scene7/services/IpsApiService"
    end
  end

  describe '.input_for_action' do
    subject { Scene7::Client }

    it "camel-cases and appends 'Param' to the action name" do
      subject.input_for_action(:get_foo).should == 'getFooParam'
    end
  end
  
  describe '.company_handle' do
    subject { Scene7::Client }

    before do
      Scene7::Client.configure(valid_config_hash)
    end

    it "retrieves the company and returns its handle" do
      Scene7::Company.expects(:find_by_name).with(valid_config_hash[:app_name]).returns(mock(:handle => 'c|11'))
      subject.company_handle.should == 'c|11'
    end
  end

end
