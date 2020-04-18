module UsersBackofficeHelper
  def verify_img
    avatar = current_user.user_profile.avatar
    avatar.attached? ? avatar : 'img.jpg'  
  end
end
