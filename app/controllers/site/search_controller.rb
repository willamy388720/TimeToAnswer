class Site::SearchController < SiteController
  def questions
    @questions = Question.includes(:answers).where("description LIKE ?", "%#{params[:term]}%").page(params[:page])
  end
end
