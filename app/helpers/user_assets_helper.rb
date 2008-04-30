module UserAssetsHelper
  def attachable_name
    # we know that @attachable is a User
    @attachable.name
  end
end