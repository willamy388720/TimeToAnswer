module UsersBackoffice::ProfileHelper
  def gender_select(user, current_gender)
    user.user_profile.gender == current_gender ? 'btn-primary' : 'btn-default'
  end

  def verify_date(user)
    unless user.user_profile.birthdate.blank?
      I18n.l(user.user_profile.birthdate)
    else
      ""
    end
  end
end
