module Scene7
  class Folder
    attr_reader :attributes

    class << self
      def all
        response = Client.perform_request(:get_folders, :company_handle => Client.company_handle) 

        folder_hashes = response.to_hash[:get_folders_return][:folder_array][:items]

        folder_hashes.map { |folder_hash| self.new(folder_hash) }
      end

      def find_by_handle(handle)
        all.detect { |folder| folder.handle == handle } 
      end

      def create(params)
        raise ":folder_path is required to create a folder" unless params[:folder_path]

        base_request_params = {:company_handle => Client.company_handle, :order! => [:company_handle, :folder_path]}
        full_request_params = base_request_params.merge(params)

        response   = Client.perform_request(:create_folder, full_request_params)
        attributes = response.to_hash[:create_folder_return]

        new(attributes)
      end

    end

    def initialize(attributes)
      @attributes = attributes
    end

    def destroy
      response = Client.perform_request(:delete_folder, :company_handle => Client.company_handle, :folder_handle => self.handle, :order! => [:company_handle, :folder_handle])

      return response.http.code == 200
    end

    # folderHandle
    def handle
      attributes[:folder_handle]
    end

    def path
      attributes[:path]
    end

    def last_modified
      attributes[:last_modified]
    end

    def has_subfolders
      attributes[:has_subfolders]
    end

  end
end
