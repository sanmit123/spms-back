class User < ApplicationRecord
    def authenticate(password)
        self.password_hash ==Digest::SHA256.hexdigest(password)
    end
end