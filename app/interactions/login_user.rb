class LoginUser < ActiveInteraction::Base
    string :email
    string :password

    def execute
        ActiveRecord::Base.transaction do
            execute_transaction_code
        end
    end

    def execute_transaction_code
        user = User.find_by_email(self.email)

        if user.nil?
            self.errors.add(:user, "does not exist")
            return
        end

        password_correct = user.authenticate(self.password)

        if !password_correct
            self.errors.add(:password, "is not correct")
            return
        end

        session = UserSession.new({
            user_id: user.id,
            expiry_at: Time.zone.now + 1.day
         })

        unless session.save!
            self.errors.merge!(user.errors)
            return
        end

        return { token: session.id }
    end
end