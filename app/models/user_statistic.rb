class UserStatistic < ApplicationRecord
  belongs_to :user

  def total_questions
    self.right_questions + self.wrong_questions
  end

  def self.set_statistic(answer, current_user)
    if !!current_user
      user_statistic = find_or_create_by(user: current_user)
      if answer.correct?
        user_statistic.right_questions += 1
      else
        user_statistic.wrong_questions += 1
      end 
      user_statistic.save
    end
  end
end
