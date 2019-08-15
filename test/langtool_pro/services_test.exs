defmodule LangtoolPro.ServicesTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory
  alias LangtoolPro.{Services, Services.Service}

  setup [:create_service]

  @service_params %{
    name: "systran"
  }

  @invalid_service_params %{
    name: ""
  }

  describe ".list_services" do
    test "returns list of services", %{service: service} do
      result = Services.list_services()

      assert length(result) == 1
      assert Enum.at(result, 0).id == service.id
    end
  end

  describe ".get_service" do
    test "returns service for existed object", %{service: service} do
      assert service.id == Services.get_service(service.id).id
    end

    test "returns nil for unexisted object", %{service: service} do
      assert nil == Services.get_service(service.id + 1)
    end
  end

  describe ".change_service" do
    test "returns changeset", %{service: service} do
      assert %Ecto.Changeset{data: %Service{}} = Services.change_service(service)
    end
  end

  describe ".create_service" do
    test "does not create service for invalid params" do
      assert {:error, %Ecto.Changeset{}} = @invalid_service_params |> Services.create_service()
    end

    test "creates service for valid params" do
      assert {:ok, %Service{}} = @service_params |> Services.create_service()
    end
  end

  describe ".delete_service" do
    test "deletes service for existed service", %{service: service} do
      assert {:ok, %Service{}} = Services.delete_service(service)
    end
  end

  defp create_service(_) do
    service = insert(:service)
    {:ok, service: service}
  end
end