defmodule LangtoolProWeb.Router do
  use LangtoolProWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LangtoolProWeb do
    pipe_through :browser

    get "/", PageController, :index, as: :welcome
    # signup routes
    get "/signup", RegistrationController, :new
    resources "/registration", RegistrationController, only: [:create]
    # sessions resources
    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
    delete "/signout", SessionController, :delete
  end
end
