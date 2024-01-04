class ListQuotations < ActiveInteraction::Base
    string :created_at_greater_than, default: nil
    string :user_id, default: nil

    def execute
        quotations = Quotation.includes(:user)

        quotations = quotations.where('updated_at >= ?', self.created_at_greater_than) if self.created_at_greater_than.present?

        quotations = quotations.where(user_id: self.user_id) if self.user_id.present?
        
        quotations = quotations.as_json(include: { user: { only: [:id, :name, :email] } })

        { list: quotations }
    end
end