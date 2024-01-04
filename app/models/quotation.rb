class Quotation < ApplicationRecord
    has_many :audits, class_name: :QuotationAudit, as: :object

    belongs_to :user, class_name: :User
end