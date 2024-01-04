class ApiController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :run_api

    def run_api
        base_url, api_path = request.path.split('/')

        unless authenticate_permission(api_path)
            render json: 'You are not authorized', status: :forbidden and return
        end

        interaction = api_path.camelize.constantize

        interaction_response = interaction.run(params)

        response = {}

        begin
            if interaction_response.valid?
                response[:result] = interaction_response.result
            else
                response[:errors] = interaction_response.errors.messages
            end
        rescue Exception => exception
            render json: exception.message , status: :internal_server_error
        end

        if response[:errors].present?
            render json: response[:errors], status: :bad_request and return
        end

        render json: response[:result], status: :ok and return
    end

    def authenticate_permission(api_path)
        api_conf = $API_REG[api_path.to_sym]

        return true if api_conf[:access_type] == 'public'

        auth_token = request.headers['Authorization'].to_s.split('Bearer: ').last

        if auth_token.present?
            user = GetSession.run(id: auth_token)

            return true if user.valid?
        end

        return false
    end

end