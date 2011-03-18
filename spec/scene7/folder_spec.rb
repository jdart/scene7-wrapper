require 'spec_helper'

describe Scene7::Folder do
  subject { Scene7::Folder }
  let(:valid_config) { {:subdomain => 'test-instance', :user => 'test@example.com', :password => 'password', :app_name => 'MyAppName', :app_version => '1.2' } }

  describe "public API" do
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

    describe ".all" do
      it "retrieves all folders" do
        savon.expects(:get_folders).with(:company_handle => "111").returns(:folders)

        subject.all
      end

      it "retrives a collection of Folders" do
        savon.stubs(:get_folders).with(:company_handle => "111").returns(:folders)

        folders = subject.all

        folders.all? { |f| f.is_a?(subject) }.should be_true
      end

      it "returns folders that are properly initialized" do
        savon.stubs(:get_folders).with(:company_handle => "111").returns(:folders)

        folders = subject.all

        folder = folders.first

        folder.handle.should          == "handle-1"
        folder.path.should            == "folder-path-1"
        folder.last_modified.should   == "20080726T08:36:19.19305:00"
        folder.has_subfolders.should  == true
      end
    end

    describe ".find_by_file_handle" do
      it "should return a single folder instance" do
        savon.stubs(:get_folders).with(:company_handle => "111").returns(:folders)
       
        folder = Scene7::Folder.find_by_handle("handle-2")

        folder.handle.should == "handle-2"
        folder.path.should   == "folder-path-2"
      end

      it "should return nil if the file does not exist" do
        savon.stubs(:get_folders).with(:company_handle => "111").returns(:folders)
       
        Scene7::Folder.find_by_handle("non-existant-handle").should be_nil
      end
    end

    describe ".create" do
      pending "it handles errors"
        # already exists
        # bad path

      it "creates a folder" do
        savon.expects(:create_folder).with(:company_handle => "111", :folder_path => "SomeRoot/SomeFolder", :order! => [:company_handle, :folder_path]).returns(:folder)

        subject.create(:folder_path => "SomeRoot/SomeFolder")
      end

      it "should return a folder that knows its handle" do
        savon.stubs(:create_folder).with(:company_handle => "111", :folder_path => "SomeRoot/SomeFolder").returns(:folder)

        response = subject.create(:folder_path => "SomeRoot/SomeFolder")

        response.handle.should == "exampleFolderHandle"
      end

      it "should raise an error if folder path is not set" do
        savon.stubs(:create_folder)

        expect { subject.create(:bogus_param => "bogus!") }.should raise_error(RuntimeError, ":folder_path is required to create a folder")
      end
    end

    describe "#destroy" do
      it "should destroy a folder" do
        folder = Scene7::Folder.new(:folder_handle => "folder-handle-1")

        savon.expects(:delete_folder).with(:company_handle => "111", :folder_handle => "folder-handle-1", :order! => [:company_handle, :folder_handle]).returns(:empty_response)

        folder.destroy
      end

      it "should return true if the deletion is successful" do
        folder = Scene7::Folder.new(:folder_handle => "folder-handle-1")

        savon.stubs(:delete_folder).with(:company_handle => "111", :folder_handle => "folder-handle-1").returns(:empty_response)

        folder.destroy.should be_true
      end

      pending "error handling"
    end

  end
end
