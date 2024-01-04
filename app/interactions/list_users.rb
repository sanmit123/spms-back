class ListUsers < ActiveInteraction::Base
    string :query
    string :user_type, default: nil

    def execute
        users = User.where('name ilike ?', "%%").select(:id, :name, :email)

        users = users.where(user_type: self.user_type) if self.user_type.present?

        { list:  users.as_json }
    end
end