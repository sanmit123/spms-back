Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  apis = Dir.glob("#{Rails.root.join('apis')}/*")
  $API_REG = {}
  apis.each do |api|
    service_name = api.split('/').last.split('.').first.delete_suffix('_apis')

    api_data = JSON.parse(File.read(api)).each { |_, v| v[:service] = service_name }
    $API_REG.merge!(api_data.deep_symbolize_keys)
  end

  $API_REG.each do |api, api_config|
    send(api_config[:method], api, to: "api##{api}")
    ApiController.define_method api.to_sym do
    end
  end
end
