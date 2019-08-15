defmodule LangtoolProWeb.TasksView do
  use LangtoolProWeb, :view
  alias LangtoolPro.TranslationKeys

  def translation_keys_of_user(user_id) do
    TranslationKeys.get_translation_keys_for_user(user_id)
  end
end
