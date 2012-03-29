class UserPresenter
  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      name:               @user.name,
      screen_name:        @user.screen_name,
      profile_image_url:  @user.profile_image_url,
      wants:              @user.wants
    }
  end
end