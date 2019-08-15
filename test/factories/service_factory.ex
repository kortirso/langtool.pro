defmodule LangtoolPro.ServiceFactory do
  alias LangtoolPro.Services.Service

  defmacro __using__(_opts) do
    quote do
      def service_factory do
        %Service{
          name: "systran"
        }
      end
    end
  end
end
