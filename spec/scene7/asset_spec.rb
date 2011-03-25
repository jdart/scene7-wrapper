require 'spec_helper'

describe Scene7::Asset do
  subject { Scene7::Asset }
  let(:valid_config) { {:subdomain => 'test-instance', :user => 'test@example.com', :password => 'password', :app_name => 'MyAppName', :app_version => '1.2' } }

  describe "class methods" do
    before do
      Scene7::Client.configure(valid_config)
      Scene7::Client.stubs(:company_handle).returns('111')
      Scene7::Client.stubs(:header).returns({
        :auth_header => {
        :user => 'test@example.com',
        :password => 'password',
        :app_name => 'Example.com',
        :app_version => '1.0'
      },
        :attributes! => { :auth_header => { :xmlns => "http://www.scene7.com/IpsApi/xsd" } }
      })
    end

    describe ".find_by_name" do
      context 'when xml contains one asset' do
        before do
          savon.expects(:get_assets_by_name).with(:company_handle => '111', :name_array => {:items => 'Jacket'}, :order! => [:company_handle, :name_array]).returns(:jacket_asset)
        end

        it "finds an asset" do
          asset = subject.find_by_name('Jacket')
          asset.should be_a(Scene7::Asset)
          asset.name.should == "Jacket"
        end
      end

      context 'when xml contains more than one asset' do
        before do
          savon.expects(:get_assets_by_name).with(:company_handle => '111', :name_array => {:items => 'Hat'}, :order! => [:company_handle, :name_array]).returns(:hat_asset)
        end

        it "finds an asset" do
          asset = subject.find_by_name('Hat')
          asset.should be_a(Scene7::Asset)
          asset.handle.should == "a|1234"
        end
      end
    end

    describe ".find_all_by_name" do
      context 'when xml contains zero assets' do
        before do
          savon.expects(:get_assets_by_name).with(:company_handle => '111', :name_array => {:items => 'Does not exist'}, :order! => [:company_handle, :name_array]).returns(:zero_found)
        end

        it "finds a collection containing that asset" do
          collection = subject.find_all_by_name('Does not exist')
          collection.length.should == 0
        end
      end

      context 'when xml contains one asset' do
        before do
          savon.expects(:get_assets_by_name).with(:company_handle => '111', :name_array => {:items => 'Jacket'}, :order! => [:company_handle, :name_array]).returns(:jacket_asset)
        end

        it "finds a collection containing that asset" do
          collection = subject.find_all_by_name('Jacket')
          collection.length.should == 1
          collection.first.name.should == "Jacket"
        end
      end

      context 'when xml contains more than one asset' do
        before do
          savon.expects(:get_assets_by_name).with(:company_handle => '111', :name_array => {:items => 'Hat'}, :order! => [:company_handle, :name_array]).returns(:hat_asset)
        end

        it "finds a collection containing the assets" do
          collection = subject.find_all_by_name('Hat')
          collection.length.should == 2
          collection.first.handle.should == "a|1234"
          collection.second.handle.should == "a|1235"
        end
      end
    end

    describe '.create' do
      before do
        subject.stubs(:job_name).returns("12345678901234567890")

        savon.expects(:submit_job).with({
          :company_handle   => '111',
          :job_name         => '12345678901234567890',
          :upload_urls_job  => {
          :url_array => {
          :items => {
          :source_url            => "http://example.com/image.jpg",
          :dest_path             => "SomeRoot/SomeDirectory/image.jpg",
          :order!                => [:source_url, :dest_path]
        }
        },
          :overwrite          => false,
          :ready_for_publish  => true,
          :create_mask        => false,
          :email_setting      => "None",
          :order!           => [:url_array, :overwrite, :ready_for_publish, :create_mask, :email_setting]
        }, 
          :order!           => [:company_handle, :job_name, :upload_urls_job] 
        }).returns(:upload_urls_job_response)
      end

      it "returns once the image object exists" do
        asset_mock = mock()
        Scene7::Asset.stubs(:find_by_name).with("image").returns(nil, asset_mock)
        asset = subject.create(:source_url => "http://example.com/image.jpg", :dest_path => "SomeRoot/SomeDirectory/image.jpg")
        asset.should == asset_mock
      end
    end

    describe ".job_name" do
      it "returns a 20-char hash of the name and current time" do
        Timecop.freeze do
          require 'digest/sha1'
          name = Digest::SHA1.hexdigest("test#{Time.now.usec}")[0..20]

          subject.job_name("test").should == name
        end
      end
    end
  end

  describe "initialization" do
    let(:attributes) { {:a => 7, :b => 11, :name => "MY_hero", :asset_handle => "...asset handle..." } }
    subject { Scene7::Asset.new(attributes) }

    its(:attributes) { should == attributes }
    its(:name) { should == "MY_hero" }
    its(:handle) { should == "...asset handle..." }
  end

  describe "#rename" do
    let(:attributes) { {:a => 7, :b => 11, :name => "MY_hero", :asset_handle => "222" } }
    subject { Scene7::Asset.new(attributes) }

    before do
      Scene7::Client.configure(valid_config)
      Scene7::Client.stubs(:company_handle).returns('111')
    end

    it "renames the object" do
      savon.expects(:rename_asset).with({
        :company_handle => "111",
        :asset_handle => "222",
        :new_name => "new name",
        :validate_name => true,
        :rename_files => true,
        :order! => [:company_handle, :asset_handle, :new_name, :validate_name, :rename_files]
      }).returns(:success)

      subject.rename("new name").should be_true
      subject.name.should == "new name"
    end

    it "does not rename the asset if there is a conflict" do
      savon.expects(:rename_asset).with({
        :company_handle => "111",
        :asset_handle => "222",
        :new_name => "new name",
        :validate_name => true,
        :rename_files => true,
        :order! => [:company_handle, :asset_handle, :new_name, :validate_name, :rename_files]
      }).returns(:failure)

      expect { subject.rename("new name") }.to raise_error("Could not rename the file -- name already taken.")
    end
  end

  describe "#destroy" do
    before { Scene7::Client.configure(valid_config) }
    let(:attributes) { {:a => 7, :b => 11, :name => "MY_hero", :asset_handle => "222" } }
    subject { Scene7::Asset.new(attributes) }

    it "deletes the asset" do
      Scene7::Client.expects(:company_handle).returns("111")
      savon.expects(:delete_asset).with(:company_handle => "111", :asset_handle => "222", :order! => [:company_handle, :asset_handle]).returns(:success)
      subject.destroy.should be_true
    end
  end
  
  describe "publish" do
     before { Scene7::Client.configure(valid_config) }
     subject { Scene7::Asset }
     
     it "publishes to the enterprise internet-ready environment" do
       subject.stubs(:job_name).returns("12345678901234567890")
       Scene7::Client.expects(:company_handle).returns("111")
       
       savon.expects(:submit_job).with({
          :company_handle        => "111", 
          :job_name              => "12345678901234567890",
          :image_serving_publish_job  => {
            :publish_type          => "Full",
            :email_setting         => "None",
            :order!                => [:publish_type, :email_setting]
          }, 
          :order!           => [:company_handle, :job_name, :image_serving_publish_job] 
       }).returns(:image_serving_publish_job_response)
       
       subject.publish
     end
   end
end
