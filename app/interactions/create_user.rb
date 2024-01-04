class CreateUser < ActiveInteraction::Base
    string :email
    string :password, default: SecureRandom.hex(10)
    string :name
    string :user_type, default: 'customer'

    def execute
        ActiveRecord::Base.transaction do
            execute_transaction_code
        end
    end

    def execute_transaction_code
        user = User.find_by_email(self.email)

        if user.present?
            self.errors.add(:user, "already exists")
            return
        end

        user = User.new(get_params)

        unless user.save!
            self.errors.merge!(user.errors)
            return
        end

        return user
    end

    def get_params
        params = @_interaction_inputs.except(:password)

        return params.merge!({
            password_hash: Digest::SHA256.hexdigest(self.password),
            user_type: self.user_type
         })
    end
end