module Scene7
  class Company
    def self.find_by_name(name)
      response = Scene7::Client.perform_request(:get_company_info, :company_name => name)
      
      company_data = response.to_hash[:get_company_info_return][:company_info]
      
      new(company_data)
    end

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def name
      attributes[:name]
    end

    def handle
      attributes[:company_handle]
    end

    def root_path
      attributes[:root_path]
    end
  end
end
