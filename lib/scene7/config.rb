require 'active_support/core_ext'

module Scene7
  class Config
    attr_reader :user, :password, :app_name, :app_version, :subdomain
    
    AUTH_NAMESPACE = "http://www.scene7.com/IpsApi/xsd"

    def initialize(subdomain, user, password, app_name, app_version)
      @subdomain   = subdomain
      @user        = user
      @password    = password
      @app_name    = app_name
      @app_version = app_version
    end

    def endpoint
      "https://#{subdomain}.scene7.com/scene7/services/IpsApiService"
    end

    def header
      {
        :auth_header => {
        :user => user,
        :password => password,
        :app_name => app_name,
        :app_version => app_version
      },
        :attributes! => { :auth_header => { :xmlns => AUTH_NAMESPACE } }
      }
    end
  end
end
