defmodule LangtoolPro.Factory do
  use ExMachina.Ecto, repo: LangtoolPro.Repo
  use LangtoolPro.UserFactory
  use LangtoolPro.TranslationKeyFactory
  use LangtoolPro.TaskFactory
  use LangtoolPro.ServiceFactory
end
