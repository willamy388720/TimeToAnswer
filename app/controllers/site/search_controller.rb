class Site::SearchController < SiteController
  def questions
    @questions = Question._search_(params[:term], params[:page])
  end
end
