class ListQuotations < ActiveInteraction::Base

    def execute
        { list: Quotation.includes(:user).as_json(include: { user: { only: [:id, :name, :email] } } ) }
    end
end