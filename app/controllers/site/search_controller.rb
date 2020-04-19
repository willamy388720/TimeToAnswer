class Site::SearchController < SiteController
  def questions
    @questions = Question.search(params[:term], page: params[:page], per_page: 5)
  end

  def subject
    @questions = Question._search_subject_(params[:subject_id], params[:page])
  end
end
