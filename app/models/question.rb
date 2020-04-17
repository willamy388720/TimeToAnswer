class Question < ApplicationRecord
  belongs_to :subject, counter_cache: true, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  paginates_per 5

  scope :_search_, ->(term, page){
    includes(:answers, :subject).where("description LIKE ?", "%#{term}%").page(page)
  }
  scope :_search_subject_, ->(subject_id, page){
    includes(:answers, :subject).where(subject_id: subject_id).page(page)
  }
end
