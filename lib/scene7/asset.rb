require 'digest/sha1'

module Scene7
  class Asset

    class << self
      def find_by_name(name)
        find_all_by_name(name).first
      end

      def find_all_by_name(name)
        response = Client.perform_request(:get_assets_by_name,
            :company_handle => Client.company_handle,
            :name_array     => {:items => name},
            :order!         => [:company_handle, :name_array]
        )

        attributes = response.to_hash[:get_assets_by_name_return][:asset_array][:items] rescue []

        collection = attributes.is_a?(Array) ? attributes : [attributes]

        collection.map! { |asset| new(asset) }
      end

      def create(params)
        source_url = params.delete(:source_url)
        dest_path  = params.delete(:dest_path)

        request = {
          :company_handle   => Client.company_handle,
          :job_name         => job_name(source_url),
          :upload_urls_job  => {
            :url_array => {
              :items => {
                :source_url            => source_url,
                :dest_path             => dest_path,
                :order!                => [:source_url, :dest_path]
              }
            },
            :overwrite          => true,
            :ready_for_publish  => true,
            :create_mask        => false,
            :email_setting      => "None",
            :order!           => [:url_array, :overwrite, :ready_for_publish, :create_mask, :email_setting]
          },
          :order!           => [:company_handle, :job_name, :upload_urls_job]
        }

        Client.perform_request(:submit_job, request)

        asset = nil
        1.upto(20) do
          break if asset
          sleep 1
          asset = find_by_name(File.basename(dest_path, File.extname(dest_path)))
        end

        raise "Could not create asset" if asset.nil?

        asset
      end

      def job_name(name)
        Digest::SHA1.hexdigest("#{name}#{Time.now.usec}")[0..20]
      end

      def stop_publish_job
        if job_handle = current_publish_job
          Client.perform_request(:stop_job, {
            :company_handle => Client.company_handle,
            :job_handle     => job_handle,
            :order!         => [:company_handle, :job_handle]
          })
        end
      end

      def current_publish_job
        response = Client.perform_request(:get_active_jobs, {
          :company_handle => Client.company_handle
        })

        publish_jobs = response.to_hash[:get_active_jobs_return][:job_array][:items].detect{ |item| item[:image_serving_publish_job] } rescue []
        publish_jobs[:job_handle] rescue nil
      end

      def publish
        Client.perform_request(:submit_job, {
          :company_handle        => Client.company_handle,
          :job_name              => job_name("publish-"),
          :image_serving_publish_job  => {
            :publish_type          => "Full",
            :email_setting         => "None",
            :order!                => [:publish_type, :email_setting]
          },
          :order!           => [:company_handle, :job_name, :image_serving_publish_job]
        })
      end
    end

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def name
      attributes[:name]
    end

    def rename(new_name)
      response = Client.perform_request(:rename_asset, {
        :company_handle => Client.company_handle,
        :asset_handle => handle,
        :new_name => new_name,
        :validate_name => true,
        :rename_files => true,
        :order! => [:company_handle, :asset_handle, :new_name, :validate_name, :rename_files]
      })

      @attributes[:name] = new_name
      return true
    rescue Savon::SOAP::Fault
      raise "Could not rename the file -- name already taken."
    end

    def handle
      attributes[:asset_handle]
    end

    def destroy
      response = Client.perform_request(:delete_asset, :company_handle => Client.company_handle, :asset_handle => handle, :order! => [:company_handle, :asset_handle])
      response.http.code == 200
    end

  end
end
