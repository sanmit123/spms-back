class GetSession < ActiveInteraction::Base
    string :id

    def execute
        session = UserSession.find(self.id)

        if session.expiry_at < Time.zone.now
            self.errors.add(:session, "is expired")
            return
        end

        return User.find(session.user_id).slice(:name, :id, :email)
    end
end