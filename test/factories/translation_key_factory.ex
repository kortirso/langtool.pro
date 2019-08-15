defmodule LangtoolPro.TranslationKeyFactory do
  alias LangtoolPro.TranslationKeys.TranslationKey

  defmacro __using__(_opts) do
    quote do
      def translation_key_factory do
        %TranslationKey{
          name: sequence(:name, &"Key_#{&1}"),
          value: "some_value",
          user: build(:user),
          service: build(:service)
        }
      end
    end
  end
end
