require 'active_support/core_ext'

module Scene7
  module Crop
    def self.convert_from_scale_first_and_format(params)
      format_url_params convert_params_from_scale_first(params)
    end

    def self.format_url_params(params)
      "scl=#{params[:scale_factor]}&crop=#{params[:x].round},#{params[:y].round},#{params[:width].round},#{params[:height].round}&qlt=#{params[:quality] || 95}"
    end

    def self.convert_params_from_scale_first(orig_params)
      {}.tap do |params|
        scale_factor = orig_params[:scale_factor].to_f
        params[:scale_factor] = 1.0 / scale_factor
        params[:height] = orig_params[:height].to_f / scale_factor
        params[:width] = orig_params[:width].to_f / scale_factor
        params[:x] = orig_params[:x].to_f / scale_factor
        params[:y] = orig_params[:y].to_f / scale_factor
        params[:quality] = orig_params[:quality] if orig_params[:quality]
      end
    end
  end
end
