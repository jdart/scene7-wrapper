require 'spec_helper'

describe Scene7::Config do
  subject { Scene7::Config }
  let(:valid_options) { ['test-instance', 'test@example.com', 'password', 'MyAppName', '1.2'] }

  describe ".new" do
    it "configures a subdomain" do
      config = subject.new(*valid_options)
      config.subdomain.should == 'test-instance'
    end

    it "configures a user" do
      config = subject.new(*valid_options)
      config.user.should == "test@example.com"
    end

    it "configures a password" do
      config = subject.new(*valid_options)
      config.password.should == "password"
    end

    it "configures an app name" do
      config = subject.new(*valid_options)
      config.app_name.should == "MyAppName"
    end

    it "configures an app_version" do
      config = subject.new(*valid_options)
      config.app_version.should == "1.2"
    end

    describe 'app_version' do
      it "is cast to a string" do
        config = subject.new(*valid_options)
        config.app_version.should == "1.2"
      end
    end
  end

  describe '#endpoint' do
    subject { Scene7::Config.new(*valid_options) }

    it 'returns the endpoint containing the subdomain' do
      subject.endpoint.should == 'https://test-instance.scene7.com/scene7/services/IpsApiService'
    end
  end

  describe 'AUTH_NAMESPACE' do
    Scene7::Config::AUTH_NAMESPACE.should == "http://www.scene7.com/IpsApi/xsd"
  end

  describe '#header' do
    subject { Scene7::Config.new(*valid_options) }

    it "returns a hash containing the auth info" do
      subject.expects(:user).returns('test@example.com')
      subject.expects(:password).returns('mypassword')
      subject.expects(:app_name).returns('Example.com')
      subject.expects(:app_version).returns('1.0')

      header = subject.header

      header[:auth_header].should == {
        :user => 'test@example.com',
        :password => 'mypassword',
        :app_name => 'Example.com',
        :app_version => '1.0'
      }

      header[:attributes!].should == {
        :auth_header => { :xmlns => "http://www.scene7.com/IpsApi/xsd" }
      }

    end
  end
end
