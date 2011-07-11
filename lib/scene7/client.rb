require 'active_support/core_ext'

module Scene7
  class Client
    cattr_reader :configuration

    CONFIG_FIELDS = [:subdomain, :user, :password, :app_name, :app_version].freeze
    NAMESPACE = "http://www.scene7.com/IpsApi/xsd/2010-01-31"

    class << self
      def configure(options)
        params = CONFIG_FIELDS.map { |field| options[field] }

        @@configuration = Config.new(*params)

        self
      end

      def reset_configuration
        @@configuration = nil
        @@company_handle = nil
      end

      def client
        Savon::Client.new do
          wsdl.namespace = NAMESPACE
          wsdl.endpoint  = configuration.endpoint
        end
      end

      def perform_request(action, body_params)
        client.request(:ns, action) do
          http.auth.ssl.verify_mode = :none

          soap.input  = [input_for_action(action), {:xmlns => "http://www.scene7.com/IpsApi/xsd/2010-01-31" }]
          soap.header = header
          soap.body   = body_params
        end
      end

      def header
        if configuration.blank?
          raise 'Call Scene7::Client.configure with your configuration first.'
        else
          configuration.header
        end
      end
      
      def company_handle
        @@company_handle ||= Company.find_by_name(configuration.app_name).handle
      end

      def input_for_action(action)
        action.to_s.camelize(:lower) + 'Param'
      end
    end
  end
end
