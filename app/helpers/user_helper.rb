module UserHelper
  def user_type(current_user)
    if current_user.has_role? :interlocutor, :any
      'interlocutor'
    else
      'no_interlocutor'
    end
  end

  def login_to_full_name(login)
    User.find_by(login: login).try(:full_name)
  end
end