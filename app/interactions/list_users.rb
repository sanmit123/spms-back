class ListUsers < ActiveInteraction::Base
    string :query

    def execute
        { list: User.where('name ilike ?', "%%").select(:id, :name, :email).as_json }
    end
end