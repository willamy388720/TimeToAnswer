class Question < ApplicationRecord
  belongs_to :subject, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  paginates_per 5

  scope :_search_, ->(term, page){
    includes(:answers).where("description LIKE ?", "%#{term}%").page(page)
  }
end
