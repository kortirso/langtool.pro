defmodule LangtoolProWeb.TranslationKeyPolicy do
  alias LangtoolPro.{Users.User, TranslationKeys.TranslationKey}

  def edit?(%User{id: id}, %TranslationKey{user_id: user_id}), do: user_id == id

  def update?(user, object), do: edit?(user, object)

  def delete?(user, object), do: edit?(user, object)
end