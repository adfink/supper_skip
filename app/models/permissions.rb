class Permissions
  def initialize(user)
    @user = user
  end

  def can_edit_restaurant?(restaurant)
    @user.verify?("admin", restaurant) || @user.staff?(restaurant)
  end
end
