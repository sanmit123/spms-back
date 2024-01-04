class UpdateQuotation < ActiveInteraction::Base
    string :performed_by_id
    string :user_id
    string :url
    string :id

    def execute
        ActiveRecord::Base.transaction do
            execute_transaction_code
        end
    end

    def execute_transaction_code
        quote = Quotation.find(self.id)

        quote.assign_attributes(get_params)

        unless quote.save!
            self.errors.merge!(quote.errors)
            return
        end

        quote.audits.create(get_audit_params(quote))

        return { id: quote.id }
    end

    def get_audit_params(quote)
        {
            performed_by_id: self.performed_by_id,
            data: { 
                user_id: self.user_id,
                url: self.url,
                sent_at: quote.updated_at
            },
            action_name: 'update'
        }
    end

    def get_params
        @_interaction_inputs
    end
end