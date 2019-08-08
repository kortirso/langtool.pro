defmodule LangtoolProWeb.Router do
  use LangtoolProWeb, :router

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
    get "/preview_emails/:name/:type", LangtoolProWeb.PreviewEmailController, :show
  end

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
    get "/registration/complete", RegistrationController, :complete, as: :complete
    get "/registration/confirm", RegistrationController, :confirm, as: :confirm
    # sessions resources
    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
    delete "/signout", SessionController, :delete
    # settings
    resources "/settings", SettingsController, only: [:index]
    resources "/translation_keys", TranslationKeysController, only: [:index]
  end
end
