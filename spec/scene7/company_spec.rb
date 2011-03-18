require 'spec_helper'

describe Scene7::Company do
  describe "initialization" do
    it "stores attributes" do
      attributes = {:a => 7, :b => 11} 

      Scene7::Company.new(attributes).attributes == attributes
    end
  end

  describe "#name" do
    it "pulls its data from stored attributes" do
      attributes = {:name => "Example.com"} 

      Scene7::Company.new(attributes).name.should == "Example.com"
    end
  end

  describe "#handle" do
    it "pulls its data from stored attributes" do
      attributes = {:company_handle => "...company handle..."} 

      Scene7::Company.new(attributes).handle.should == "...company handle..."
    end
  end

  describe "#root_path" do
    it "pulls its data from stored attributes" do
      attributes = {:root_path => "Example.com/"} 

      Scene7::Company.new(attributes).root_path.should == "Example.com/"
    end
  end

  describe ".find_by_name" do
    subject { Scene7::Company }
  let(:valid_config) { {:subdomain => 'test-instance', :user => 'test@example.com', :password => 'password', :app_name => 'MyAppName', :app_version => '1.2' } }

    before do
      Scene7::Client.configure(valid_config)
      Scene7::Client.stubs(:header).returns({
        :auth_header => {
          :user => 'test@example.com',
          :password => 'password',
          :app_name => 'Example.com',
          :app_version => '1.0'
        },
        :attributes! => { :auth_header => { :xmlns => "http://www.scene7.com/IpsApi/xsd" } }
      })

      savon.expects(:get_company_info).with(:company_name => "Example.com").returns(:company)
    end

    it "finds a company" do
      subject.find_by_name('Example.com').should be_a(Scene7::Company)
    end

    it "has the right handle" do
      subject.find_by_name('Example.com').handle.should == "111"
    end
  end
end
