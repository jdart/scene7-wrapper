require 'active_support/core_ext'

module Scene7
  module Crop
    def self.convert_from_scale_first_and_format(params, additional_params = {})
      format_url_params convert_params_from_scale_first(params, additional_params)
    end

    def self.format_url_params(params)
      require 'cgi' unless defined?(CGI) && defined?(CGI::escape)

      basic = "scl=#{params.delete(:scale_factor)}&crop=#{params.delete(:x).round},#{params.delete(:y).round},#{params.delete(:width).round},#{params.delete(:height).round}&qlt=#{params.delete(:quality)}"
      basic << params.map {|k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
    end

    def self.convert_params_from_scale_first(orig_params, additional_params = {})
      {}.tap do |params|
        scale_factor = orig_params[:scale_factor].to_f
        params[:scale_factor] = 1.0 / scale_factor
        params[:height] = (orig_params[:height].to_f / scale_factor).round
        params[:width] = (orig_params[:width].to_f / scale_factor).round
        params[:x] = (orig_params[:x].to_f / scale_factor).round
        params[:y] = (orig_params[:y].to_f / scale_factor).round
        params[:quality] = orig_params[:quality] || 95
      end.merge!(additional_params)
    end
  end
end
